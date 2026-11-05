+++ 
draft = false
date = 2023-04-22T21:25:05-05:00
title = "Network State Monitor"
description = "A technical overview of a Windows service that detects network-state transitions and publishes them for diagnostics and downstream automation."
slug = ""
authors = []
tags = ["Windows", "Networking", "Automation"]
categories = []
externalLink = ""
series = []
+++

`NetworkStateMonitorService` is a Windows service that continuously classifies a computer's network connectivity and publishes network transitions for downstream automation, such as background drive mapping.

The service is a **state detector and event producer**, not a user interface. It runs headlessly, checks network posture on a timer and in response to operating-system network events, and makes state available through Windows Event Log and named-pipe IPC.

## What the service does

At runtime, the monitor:

1. Determines the current network state: `Disconnected`, `Connected`, `StateNetwork`, `PublicNetwork`, or `StateVPNNetwork`.
2. Detects state transitions and records when they occur.
3. Publishes transition information to Windows Event Log and the `CurrentNetworkState` named pipe.
4. Can participate in scheduled-task and event wiring that triggers downstream processes.
5. Can run VPN auto-connect watchdog logic while on a public network.
6. Exposes diagnostics and health information for operational tools.

## The network state model

The service uses a finite-state machine backed by several probes:

- **Link status:** checks whether the operating system reports network availability.
- **Public internet:** checks DNS or ping reachability, with an HTTP reachability check as a fallback.
- **Internal network:** probes a configured internal host.
- **VPN status:** first checks active RAS sessions, then uses network-interface characteristics and a configured private address range as a secondary signal.

The classification logic is:

1. If public internet access is unavailable, report `Disconnected`.
2. If public internet is available but the internal host is unreachable, report `PublicNetwork`.
3. If the internal host is reachable and a VPN is present, report `StateVPNNetwork`.
4. If the internal host is reachable and no VPN is present, report `StateNetwork`.

The service also includes `Connected` in its state model for connectivity conditions that do not fit those more specific classifications.

## Event-driven and periodic checks

Network detection combines event-driven checks with interval polling:

- **Event-driven:** `NetworkAddressChanged` notifications and Network Profile operational log events can trigger an evaluation.
- **Interval-driven:** a timer performs regular checks. The default interval is five seconds and can be overridden with command-line arguments.

Because several network events can arrive close together, a `MinStateCheckSpacing` throttle coalesces duplicate checks. This helps avoid unnecessary work and noisy transitions during bursts of operating-system notifications.

## Publishing transitions and current state

When the state changes, the service creates a transition record containing the previous state, the new state, a timestamp, the time zone, and cached location metadata when available.

The record can be sent to console output in debug mode or written as a structured event to Windows Event Log in production. Separately, `ConnectionState.Initialize()` starts a named-pipe writer loop for `CurrentNetworkState`. Local clients can use that pipe to read a live state snapshot rather than scraping log messages.

## Keeping detection separate from execution

The monitor detects and publishes network state; it does not map drives itself. Scheduled-task triggers can respond to transition events, and a separate host can perform work in the signed-in user's session.

This separation keeps the service focused on **detection and publication**, while the user-context host owns **mapping execution**. It avoids coupling continuous network monitoring to a UI process or to a service's session, where user-specific mapped drives may not be visible.

## VPN auto-connect watchdog

When enabled, the watchdog evaluates `PublicNetwork` state and can attempt a controlled VPN reconnection. It supports matching VPN profiles against configured patterns, enforcing retry intervals, and throttling warning messages.

It can also suppress retries after repeated remote-termination failures in the error 628 class. These controls help avoid aggressive reconnect loops while still leaving useful support signals in the logs and event stream.

## Diagnostics and operator commands

The service provides command modes and configuration options for inspecting its behavior, including:

- `--status` to query the running service through the named pipe.
- `--once` to run a single connectivity and state evaluation.
- `--diagnose` for network, scheduled-task, and event-source diagnostics.
- `--dump-config` to inspect resolved runtime configuration.
- `--verify-task` to check scheduled-task configuration.
- `--diagnose-location` for time-zone and location diagnostics.
- Options such as `--check-interval`, `--min-state-duration`, `--flap-threshold`, `--health-file`, and `--health-interval` to tune monitoring and health output.

Where supported, command results can be emitted as JSON for scripts and other operational tooling.

## Flapping detection and persistence

Optional flapping detection tracks how often transitions occur and how long the current state has lasted. It writes a `flapping-status.json` snapshot with the monitoring-enabled and flapping flags, transition counts over the last minute and five minutes, and the current state and its duration.

The service prefers shared machine-level storage. If that location is not writable, it falls back to storage in the per-user local profile.

## Health-file output

The optional `HealthCheckFileWriter` produces periodic or transition-driven JSON. Depending on the configured checks, the output can include current state and duration, public and internal reachability, VPN status and details, and metadata about the last transition.

This provides external monitoring and lightweight automation with a current health snapshot without requiring a UI.

## Security and operational boundaries

The monitor runs headlessly as a Windows service and uses a local named pipe for state retrieval. It does not depend on a UI process. Event-source creation is conditional on administrative rights, and event-log permission failures are handled explicitly so the service can report or degrade from those conditions rather than assuming it can always write.

## Practical outcome

`NetworkStateMonitorService` turns network posture from an implicit, timing-sensitive condition into an explicit, queryable stream of state. That gives downstream automation a more deterministic trigger, gives operators better diagnostic context, and reduces the ambiguity of relying on a one-time logon script.