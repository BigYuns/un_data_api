require "#{Rails.root}/lib/modules/xml_parser.rb"

class GidXmlParser < XmlParser
  def record_attributes
    @doc.elements.each("ROOT/data/record") do |record|
      record.elements.each do |element|
        element_name = element.attributes["name"]

        case element_name
        when "Country or Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          un_abrev_country_name(@country_name)
        when "Reference Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          un_abrev_country_name(@country_name)
        when "Year"
          year = element.text.to_i
          set_year(year)
        when "Year(s)"
          year = element.text.to_i
          set_year(year)
        when "Time Period"
          year = element.text.to_i
          set_year(year)
        when "Unit"
          measurement = element.text
          if measurement == "%"
            measurement = "percent"
          end
          set_record("measurement", measurement)
        when "Magnitude"
          measurement = element.text
          if measurement == "%"
            measurement = "percent"
          end
          set_record("measurement", measurement)
        when "Units of measurement"
          measurement = element.text
          if measurement == "%"
            measurement = "percent"
          end
          set_record("measurement", measurement)
        when "Value"
          value = element.text.to_f
          set_record("value", value)
        when "GENDER"
          gender = element.text
          set_record("gender", gender)
        when "Value Footnotes" 
          if element.text != nil 
            clean_footnotes(element.text)
          end
        else
          name = element_name.downcase.gsub("/ /", "_")
          set_record(name, element.text)
        end
      end
      new_record = Record.new(@record)
      new_record.save
    end
  end
end


# Agriculture, forestry and fishing
# <record>
#     <field name="Element Code">111</field>
#     <field name="Element">Seed</field>
# </record>

# Balance of payments
# <record>
#     <field name="OID">51278ACDZF...</field>
#     <field name="Description">TRADE BALANCE</field>
# </record>

# Culture and communication
# <record>
#     <field name="Reference Area">Afghanistan</field>
#     <field name="Sex">Not applicable</field>
#     <field name="Age group">Not applicable</field>
#     <field name="Observation Value">0.757956337486362</field>
# </record>

# Development assistance
# <record>
# </record>

# Education
# <record>
#     <field name="Sex">Female</field>
#     <field name="Age group">Not applicable</field>
#     <field name="Observation Value">2169036</field>
# </record>

# Environment
# <record>
#     <field name="Element Code">11</field>
#     <field name="Element">Area</field>
# </record>

# Gender
# <record>

# </record>

# International Finance
# <record>
#     <field name="OID">512..AE.ZF...</field>
#     <field name="Description">PRINCIPAL RATE, END OF PERIOD</field>
# </record>

# International merchandise trade
# <record>
#     <field name="Comm. Code">TOTAL</field>
#     <field name="Commodity">ALL COMMODITIES</field>
#     <field name="Flow">Import</field>
#     <field name="Trade (USD)">6204984101</field>
#     <field name="Weight (kg)"></field>
#     <field name="Quantity Name">No Quantity</field>
#     <field name="Quantity"></field>
# </record>

# Labour force
# <record>
#     <field name="Sex">Men</field>
#     <field name="Classification">ISIC-Rev.2</field>
#     <field name="Subclassification">2-9.</field>
#     <field name="Source">Official estimates</field>
#     <field name="SourceID"># 0</field>
# </record>

# Manufacturing
# <record>
# </record>

# National accounts and industrial production
# <record>
#     <field name="Item">General government final consumption expenditure</field>
# </record>

# Population
# <record>
#     <field name="Variant">Constant-fertility scenario</field>
# </record>

# Wages and prices
# <record>
#     <field name="Scope">Kabul</field>
#     <field name="Value">100</field>
#     <field name="Value Footnotes">1,2</field>
# </record>










