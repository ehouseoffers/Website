# Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.sleep_delay = 120
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 2.minutes
