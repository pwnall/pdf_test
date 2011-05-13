class PdfController < ApplicationController
  # GET /
  def index
    @pdf_document = PdfDocument.new
    respond_to do |format|
      format.html  # index.html
    end
  end

  # POST /pdf/generate.pdf
  def generate
    params[:pdf_document].each do |k, v|
      params[:pdf_document][k] = false if params[:pdf_document][k] == '0'
    end
    
    @pdf_document = PdfDocument.new params[:pdf_document]
    
    respond_to do |format|
      format.pdf do
        send_data @pdf_document.to_pdf, :filename => 'test.pdf',
                                        :type => 'application/pdf'
      end
    end
  end
end
