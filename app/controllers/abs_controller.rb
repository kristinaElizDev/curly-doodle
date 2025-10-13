require "azure/blob"
require "azure/core"

class AbsController < ApplicationController
  def index
    @abs_info = AbsInfoService.call
  end

  def test
    @test_results = perform_abs_tests
    render :index
  end

  private

  def perform_abs_tests
    # Minimal fake tests for ABS connectivity — replace with real SDK calls later.
    [
      {
        test: "ABS Ping",
        result: "PASS",
        details: "Simulated ABS connectivity check"
      },
      {
        test: "List Containers",
        result: "PASS",
        details: "Fake: listed containers successfully"
      },
      {
        test: "Upload Blob",
        result: "PASS",
        details: "Fake: uploaded and verified blob content"
      }
    ]
  end
end
