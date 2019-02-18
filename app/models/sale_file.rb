class SaleFile < ApplicationRecord
	# Associations
	has_one :sale

	# File upload
	attachment :file

	# Validations
	validates :file, presence: true

	# Callbacks
	after_commit :process_file

	private

	def process_file
		ProcessFileJob.perform_later(self.id)
	end
end