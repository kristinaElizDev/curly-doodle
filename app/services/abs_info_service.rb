class AbsInfoService
  # Public entrypoint. Use AbsInfoService.call to fetch ABS information.
  def self.call
    new.call
  end

  def call
    begin
      # Replace this fake return with real Azure Blob/Storage calls when ready.
      # Example:
      # blob_client = Azure::Storage::Blob::BlobService.create(...)
      # { connected: true, account: blob_client.account_name, containers: ... }
      "this is fake too"
    rescue => e
      {
        connected: false,
        error: e.message,
        suggestion: "Check your Azure configuration and network connectivity"
      }
    end
  end
end
