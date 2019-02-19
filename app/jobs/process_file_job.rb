class ProcessFileJob < ApplicationJob
  queue_as :import_file
  Sidekiq.default_worker_options = { :queue => :import_file, retry: true }

  def perform(sale_file_id)
    sale_file = SaleFile.find(sale_file_id)
    sale_file.import!
  end
end