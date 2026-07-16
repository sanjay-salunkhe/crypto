Rails.application.reloader.to_prepare do
  Thread.new do
    loop do
      FetchPriceJob.perform_later
      sleep 60
    end
  end
end