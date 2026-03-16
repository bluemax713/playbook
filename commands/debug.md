Follow this systematic debugging process:

0. **Check connectivity (only if the session is slow)** — If responses are taking unusually long, run `speedtest` (if installed) to check for high latency, packet loss, or low bandwidth. If the connection is poor (>500ms latency, >5% packet loss, or <1 Mbps upload), flag it and suggest deferring to a better connection before debugging code.
1. **Reproduce** — Confirm the bug exists. Get the exact error, query, or behavior. Don't guess.
2. **Isolate** — Narrow down the root cause:
   - What changed recently? (Check WORK_LOG.md, recent commits, recent deployments)
   - Where in the pipeline does it fail?
   - What does the data actually look like? (Query the source directly)
3. **Fix** — Apply the minimal fix. Don't refactor surrounding code.
4. **Verify** — Independently confirm the fix works:
   - Re-run the failing query/workflow
   - Check the output matches expectations
   - Confirm no regressions in related functionality

Report findings at each step. Don't skip to step 3.
