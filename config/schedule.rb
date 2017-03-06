every '0 0 1 4 *'  do
  runner 'SendVacationReminderJob.perform_later'
end