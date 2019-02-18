class FileService

	def initialize(path)
		@path = path
	end

	def zip_extension?
		mime_type == "application/zip".freeze
	end

	def text_plain_extension?
		mime_type == "text/plain".freeze
	end

	def mime_type
		`file --mime-type #{@path}`.split(" ").grep_v(/#{@path}/).last if exist?
	end

	def exist?
		value = ` if [ -e #{@path} ]; then echo true; else echo false; fi`.strip
		to_bool(value)
	end

	def allowed_extension?
		return true if zip_extension? || text_plain_extension?
	end

	def raise_invalid_extension
		raise "Arquivo com extensão inválida. Extensão: #{mime_type}"
	end

	private
	def to_bool(value)
		value=="true" ? true : false
	end

end