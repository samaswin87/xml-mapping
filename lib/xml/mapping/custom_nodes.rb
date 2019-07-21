# xml-mapping -- bidirectional Ruby-XML mapper
# Copyright (C) 2019 Aswin
require 'ostruct'
require 'active_support/core_ext'

module XML

  module Mapping

    # Node factory function synopsis:
    #
    #   attrbute_text_node :_attrname_, _path_ [, :default_value=>_obj_]
    #                                 [, :optional=>true]
    #                                 [, :mapping=>_m_]
    #
    # Node that maps an XML node's text and nodes attributes (the element's first child
    # text node resp. the attribute's value) to a (NodeAttributes) attribute
    # of the mapped object. _path_ (an XPath expression) locates the
    # XML node, _attrname_ (a symbol) names the
    # attribute. <tt>:default_value</tt> is the default value,
    # :optional=>true is equivalent to :default_value=>nil (see
    # superclass documentation for details). <tt>_m_</tt> is the
    # mapping; it defaults to the current default mapping
    # </tt>NodeAttributes<tt> is the open strut where we can find the node attributes
    # Like,
    #   <foo name="test" option="test">
    #    .....
    #   </foo>
    class AttributeTextNode < SingleAttributeNode

      class NodeAttributes < OpenStruct; end

      def initialize(*args)
        path, *args = super(*args)
        @path = XML::XXPath.new(path)
        args
      end

      def extract_attr_value(_xml) # :nodoc:
        txt = default_when_xpath_err{ @path.first(_xml).text }
        xml = @path.first(_xml)
        node_attributes = NodeAttributes.new
        node_attributes.txt = txt

        if (txt && keys = xml.attributes.keys).present?
          keys.each do |attribute|
            attribute_txt = xml.attributes[attribute]
            node_attributes.send("#{attribute}=", attribute_txt) if attribute_txt
          end
        end
        node_attributes
      end

      def obj_to_xml(obj,xml) # :nodoc:
        value = obj.send(:"#{@attrname}")
        xml = @path.first(xml, :ensure_created => true)
        value.to_h.each {|k, v|
          next if k == :txt
          xml.attributes.add(REXML::Attribute.new(k.to_s , v))
        }
        if @options.has_key? :default_value
          unless value.txt == @options[:default_value]
            xml.text = value.txt
          end
        else
          if value == nil
            raise XML::MappingError, "no value, and no default value, for attribute: #{@attrname}"
          end
          xml.text = value
        end
        true
      end

    end

    class DateNode < SingleAttributeNode

      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(_xml)
        date = default_when_xpath_err{ @path.first(_xml).text }
        date = Date.parse(date).to_date if date.present?
        date
      end

      def set_attr_value(_xml, _value)
        @path.first(xml, ensure_created: true).text = value
      end
    end

    class TimeNode < SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        value = default_when_xpath_err { @path.first(xml).text }
        value ? Time.iso8601(value).utc : nil
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.iso8601
      end
    end
  end

end
