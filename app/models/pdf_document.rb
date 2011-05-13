class PdfDocument
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  # The PDF's viewer.
  attr_accessor :password
  
  # If set, the document's DRM will disallow printing.
  attr_accessor :forbid_printing

  # If set, the document's DRM will disallow modifications.
  attr_accessor :forbid_changes
  
  # If set, the document's DRM will disallow copying to clipboard.
  attr_accessor :forbid_copying

  # If set, the document's DRM will disallow making or changing annotations.
  attr_accessor :forbid_annotations

  # Create a new PDF document and initialize attributes.
  def initialize(options = {})
    p options
    options.each { |k, v| send :"#{k}=", v }
  end

  # Returns a string containing the PDF bytes.
  def to_pdf
    pdf = Prawn::Document.new :page_size => 'LETTER', :page_layout => :portrait
    pdf.font "Helvetica"
    pdf.font_size 24
    pdf.text "This is a password-protected PDF with DRM bits."

    pdf.font "Courier"
    pdf.font_size 18
    
    permissions = {}
    { :forbid_printing => :print_document, :forbid_changes => :modify_contents,
      :forbid_copying => :copy_contents,
      :forbid_annotations => :modify_annotations
    }.each do |attr, bit|
      value = !self.send(attr)
      permissions[bit] = value
      pdf.text "#{bit.inspect} is #{value}"
    end
    
    pdf.encrypt_document :user_password => password, :owner_password => :random,
                         :permissions => permissions
    
    pdf.render
  end
  
  # Make ActiveModel happy.
  def persisted?
    false
  end
end
