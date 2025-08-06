class RequestsController < ApplicationController
  def cancel
    @request = Request.find(params[:id])
    if @request.pending? || @request.draft?
        @request.update(status: :cancelled) # hoặc status bạn muốn
        flash[:success] = "Request đã được hủy."
    else
        flash[:alert] = "Không thể hủy request này."
    end
    redirect_back fallback_location: bookings_path
    end
end
