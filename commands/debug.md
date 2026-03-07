Follow this systematic debugging process:

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
