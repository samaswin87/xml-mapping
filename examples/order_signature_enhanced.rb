class Signature
  include XML::Mapping

  def init
    @attributes = {}
  end

  text_node :name, "Name"
  text_node :position, "Position", :default_value=>"Some Employee"
  time_node :signed_on, "signed-on", :default_value=>Time.now
  attribute_text_node :signature, "user-sign", :default_value => nil
end
