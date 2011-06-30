# Pub

Pub is a Redis-backed pub with a non-blocking bar counter, or, putting aside
the metaphor for a moment, a processing queue where consumers, instead of
simply queuing jobs and getting on with their lives, queue and wait for a
response without blocking the Ruby process.

This is a barebone work-in-progress that I am about to give a test ride to in
an app I'm building.
