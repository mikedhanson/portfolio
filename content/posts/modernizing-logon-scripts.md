+++
draft = false
date = 2023-04-22T21:25:20-05:00
title = "Modernizing Logon Scripts: From Fragile Startup Tasks to Event-Driven Drive Mapping"
description = "How a service, a user-context background host, and scriptable tooling make network drive mapping more reliable than logon-only scripts."
slug = ""
authors = []
tags = ["Windows", "Automation", "C#", "Networking"]
categories = ["Code"]
externalLink = ""
series = []
+++

For years, our network drive mappings depended on traditional logon scripts. They worked—until they didn't. Timing issues during sign-in, VPN race conditions, limited diagnostics, and hard-to-reproduce user-session bugs made a simple task difficult to support.

We modernized that model into a more resilient, testable system built around a Windows service, a user-context background host, and scriptable CLI and PowerShell tooling.

## Why logon scripts became a bottleneck

Classic logon scripts assume that the network is ready at exactly the right moment: when the user signs in. In real environments, that assumption often breaks:

- A VPN connection may come up after sign-in.
- A wireless profile change can disrupt an existing mapping.
- Administrative and user sessions do not share identical drive visibility.
- Troubleshooting can become a cycle of “try logging out and back in.”

Any one of these may be manageable. At scale, they cost time for both users and support teams—and the symptoms can disappear before anyone can investigate them.

## The modernization approach

Instead of mapping drives **only** at logon, we separated detection from execution and gave each part a clear responsibility:

- **Network-state detection** is handled by `NetworkStateMonitorService`.
- **Drive-mapping execution** is handled by a lightweight background host, `NetworkDriveManager.BackgroundHost`.
- **Task Scheduler** launches mapping in the signed-in user's context.
- **The UI is optional** and is not a runtime dependency for continuous mapping.

This changes drive mapping from a one-time startup action into a workflow that can respond to network-state changes.

## What changed technically

### Service and host orchestration

The legacy model centered on scripts running at logon. The modern path prioritizes background execution triggered by network transitions. The service monitors network state; the background host performs the mapping work in the user's session.

Keeping those responsibilities separate makes each part easier to evolve and troubleshoot. It also avoids treating a network connection that was not ready at sign-in as a permanent failure.

### First-class automation and diagnostics

The application exposes command-line operations for administrators and support staff, including:

- `--healthcheck`
- `--show-health [--json]`
- `--show-drives [--json]`
- `--map-now`
- `--disconnect-all`
- `--refresh-state`
- `--gather-logs`

These commands provide deterministic, scriptable ways to inspect or trigger operations without opening the UI. JSON output also makes health and drive status easier for other scripts and support tools to consume.

### Compatibility while modernizing

The solution is aligned on modern .NET Windows targets (`net10.0-windows10.0.19041.0`) across its core projects, while keeping installer, service, and packaging workflows intact.

### Validation and regression coverage

The repository includes a Windows CI test suite with 47 automated tests. It covers core mapping logic, state transitions, service argument handling, and installer-definition regression checks.

Tests cannot guarantee that every real-world network behaves the same way, but they help catch regressions in the behavior the system is expected to provide.

## Architecture at a glance

```text
Network changes detected
        |
        v
NetworkStateMonitorService
        |  publishes a transition / trigger
        v
Task Scheduler (signed-in user context)
        |
        v
Background host mapping cycle
        |
        +-- map or unmap drives
        +-- write logs and event data
        +-- expose health and drive status via CLI / JSON
```

The service detects a change, but the mapping work runs in the signed-in user's context. That distinction matters because mapped drives are associated with a Windows logon session; running the mapping only from a service session may not make the drives visible where the user needs them.

## Practical lessons for teams modernizing logon scripts

- Treat logon as a useful hint, not the only trigger.
- Separate network-state detection from drive-mapping execution so each can evolve independently.
- Run mapping in the user context when the result needs to be visible in that user's Windows session.
- Make diagnostics machine-readable with options such as `--json`, so support tools and automation can inspect health quickly.
- Keep the UI optional; operational paths should continue to work headlessly.

## A realistic migration path

Modernization does not have to mean replacing every script at once:

1. Keep existing scripts during the transition.
2. Introduce health and drive-status commands so support can see what is happening.
3. Add network-state monitoring and scheduled execution in the user's context.
4. Move mapping into a dedicated background host.
5. Retire the logon-script-only dependency once the new workflow is observable and dependable.

Keeping the old path available during rollout gives teams time to validate behavior and troubleshoot edge cases before removing a familiar fallback.

## Final thought

Modernizing logon scripts is less about replacing a `.bat` file with a different file type and more about changing the operating model: from a best-effort action at startup to a workflow that can respond to changing network conditions.

The payoff is fewer “randomly disconnected” mornings, clearer support workflows, and a foundation that better fits hybrid networking realities.