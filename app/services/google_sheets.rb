# gets tabular data out of google sheets

require "google/apis/sheets_v4"

class GoogleSheets
  def self.fetch_range_from_sheet(sheet_id, range)
    sheet_service = Google::Apis::SheetsV4::SheetsService.new
    sheet_service.key = Rails.application.credentials.google_api_key
    return sheet_service.get_spreadsheet_values sheet_id, range
  end
end
