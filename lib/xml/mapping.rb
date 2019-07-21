# xml-mapping -- bidirectional Ruby-XML mapper
#  Copyright (C) 2004-2006 Olaf Klischat

require 'xml/mapping/base'
require 'xml/mapping/standard_nodes'
require 'xml/mapping/custom_nodes'

XML::Mapping.add_node_class XML::Mapping::Node
XML::Mapping.add_node_class XML::Mapping::TextNode
XML::Mapping.add_node_class XML::Mapping::NumericNode
XML::Mapping.add_node_class XML::Mapping::ObjectNode
XML::Mapping.add_node_class XML::Mapping::BooleanNode
XML::Mapping.add_node_class XML::Mapping::ArrayNode
XML::Mapping.add_node_class XML::Mapping::HashNode
XML::Mapping.add_node_class XML::Mapping::ChoiceNode
XML::Mapping.add_node_class XML::Mapping::AttributeTextNode
XML::Mapping.add_node_class XML::Mapping::DateNode
XML::Mapping.add_node_class XML::Mapping::TimeNode
