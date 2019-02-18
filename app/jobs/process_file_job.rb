class ProcessFileJob < ApplicationJob
  queue_as :import_file
  Sidekiq.default_worker_options = { :queue => :import_file, retry: true }

  def perform(sale_file_id)
    file = SaleFile.find(sale_file_id)
    sale_file_service = SaleFileService.new(file)
    sale_file_service.import!
  end
end