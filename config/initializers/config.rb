Workarea.configure do |config|
  # How long to wait before clearing out old, anonymous saved list
  # records. The default is 3 months, and this configures MongoDB's TTL
  # for the collection. Indexes will need to be rebuilt if this option
  # is changed.
  config.saved_lists_expiration = 3.months
end
