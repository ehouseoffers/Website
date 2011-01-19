Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay  = 880
Delayed::Worker.max_attempts = 20
Delayed::Worker.max_run_time = 3.minutes
Delayed::Worker.logger = Rails.logger