# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


countries = [
    "Australia", "Belgium", "Czech Republic", "Finland", "France", "Germany", "Italy", "Luxembourg", "Netherlands", "Norway", "Portugal", "Spain", "Sweden", "Switzerland", "United Kingdom", "United States", "Russia", "Turkey", "Ukraine", "Poland", "Romania", "Kazakhstan", "Greece", "Azerbaijan", "Hungary", "Belarus", "Austria", "Bulgaria", "Serbia", "Denmark", "Slovakia", "Ireland", "Croatia", "Georgia", "Bosnia and Herzegovina", "Armenia", "Albania", "Lithuania", "Moldova", "North Macedonia", "Slovenia", "Latvia", "Kosovo", "Estonia", "Cyprus", "Canada", "Israel", "Brazil", "Mexico"
]

# 'Create Countries'

countries.each do |country|
    if Country.where(:name => country) == []
        puts 'Create Countries'
        country_created = Country.new(name: country)
        country_created.save!
    end
end

# 'Create Languages'
# Languages
languages = ["English", "French", "Dutch", "German"]
languages.each do |language|
    if Language.where(name:language) == []
        puts 'Create Languages'
        model_language = Language.new(name:language)
        model_language.save!
    end
end

# 'Create Amounts'
# Amounts

amounts = [ "Reporting Currency Gross Amount", "Reporting Currency Taxable Basis", "Reporting Currency VAT Amount"]
amounts.each do |amount|
    if Amount.where(name: amount) == []
        puts 'Create Amounts'
        amount_name = Amount.new(name: amount)
        amount_name.save!
    end
end



language_country = {"Belgium": {'English': "Belgium", 'French': "Belgique"}, "France": {"English": "France", "French": "France"},
                    "Australia": {'English': "Australia", 'French': "Australie"}, "Czech Republic": {"English": "Czech Republic", "French": "République tchèque"},
                    "Finland": {'English': "Finland", 'French': "Finlande"}, "Germany": {"English": "Germany", "French": "Allemagne"},
                    "Italy": {'English': "Italy", 'French': "Italie"}, "Luxembourg": {"English": "Luxembourg", "French": "Luxembourg"},
                    "Netherlands": {'English': "Netherlands", 'French': "Pays-Bas"}, "Norway": {"English": "Norway", "French": "Norvège"},
                    "Portugal": {'English': "Portugal", 'French': "Portugal"}, "Spain": {"English": "Spain", "French": "Espagne"},
                    "Sweden": {'English': "Sweden", 'French': "Suède"}, "Switzerland": {"English": "Switzerland", "French": "Suisse"},
                    "United Kingdom": {'English': "United Kingdom", 'French': "Royaume-Uni"}, "United States": {"English": "United States", "French": "Etats-Unis d'Amérique"},
                    "Russia": {'English': "Russia", 'French': "Russie"}, "Turkey": {"English": "Turkey", "French": "Turquie"},
                    "Ukraine": {'English': "Ukraine", 'French': "Ukraine"}, "Poland": {"English": "Poland", "French": "Pologne"},
                    "Romania": {'English': "Romania", 'French': "Roumanie"}, "Kazakhstan": {"English": "Kazakhstan", "French": "Kazakhstan"},
                    "Greece": {'English': "Greece", 'French': "Grèce"}, "Azerbaijan": {"English": "Azerbaijan", "French": "Azerbaïdjan"},
                    "Hungary": {'English': "Hungary", 'French': "Hongrie"}, "Belarus": {"English": "Belarus", "French": "Biélorussie"},
                    "Austria": {'English': "Austria", 'French': "Autriche"}, "Serbia": {"English": "Serbia", "French": "Serbie"},
                    "Denmark": {'English': "Denmark", 'French': "Danemark"}, "Slovakia": {"English": "Slovakia", "French": "Slovaquie"},
                    "Ireland": {'English': "Ireland", 'French': "Irlande"}, "Croatia": {"English": "Croatia", "French": "Croatie"},
                    "Georgia": {'English': "Georgia", 'French': "Géorgie"}, "Bosnia and Herzegovina": {"English": "Bosnia and Herzegovina", "French": "Bosnie-Herzégovine"},
                    "Armenia": {'English': "Armenia", 'French': "Arménie"}, "Albania": {"English": "Albania", "French": "Albanie"},
                    "Lithuania": {'English': "Lithuania", 'French': "Lituanie"}, "Moldova": {"English": "Moldova", "French": "Moldavie"},
                    "North Macedonia": {'English': "North Macedonia", 'French': "Macédoine du Nord"}, "Slovenia": {"English": "Slovenia", "French": "Slovénie"},
                    "Latvia": {'English': "Latvia", 'French': "Lettonie"}, "Kosovo": {"English": "Kosovo", "French": "Kosovo"},
                    "Canada": {'English': "Canada", 'French': "Canada"}, "Cyprus": {"English": "Cyprus", "French": "Chypre"},
                    "Israel": {'English': "Israel", 'French': "Israel"}, "Estonia": {"English": "Estonia", "French": "Estonie"},
                    "Brazil": {'English': "Brazil", 'French': "Brésil"}, "Mexico": {"English": "Mexico", "French": "Mexique"},
                    "Bulgaria": {'English': "Bulgaria", 'French': "Bulgarie"}
                    }


language_country.each do |key, value|
    value.each do |language_name, name|
        country = Country.where(name: key)[0]
        if LanguageCountry.where(name: name) == []
            puts 'Create Language Country'
            # need to_s.to_i because it is a symbol
            language = Language.where(name: language_name)[0]
            language_country_save = LanguageCountry.new(name: name, language_id: language.id, country_id: country.id)
            language_country_save.save!
        end
    end
end

eu_country =    {"Belgium": "EU", "France": "EU",
                "Australia": "NON-EU", "Czech Republic": "EU",
                "Finland": "EU", "Germany": "EU",
                "Italy": "EU", "Luxembourg": "EU",
                "Netherlands": "EU", "Norway": "EU",
                "Portugal": "EU", "Spain": "EU",
                "Sweden": "EU", "Switzerland": "EU",
                "United Kingdom": "NON-EU", "United States": "NON-EU",
                "Russia": "NON-EU", "Turkey": "NON-EU",
                "Ukraine": "NON-EU", "Poland": "EU",
                "Romania": "EU", "Kazakhstan": "NON-EU",
                "Greece": "EU", "Azerbaijan": "NON-EU",
                "Hungary": "EU", "Belarus": "NON-EU",
                "Austria": "EU", "Serbia": "EU",
                "Denmark": "EU", "Slovakia": "EU",
                "Ireland": "EU", "Croatia": "EU",
                "Georgia": "NON-EU", "Bosnia and Herzegovina": "NON-EU",
                "Armenia": "NON-EU", "Albania": "NON-EU",
                "Lithuania": "EU", "Moldova": "NON-EU",
                "North Macedonia": "NON-EU", "Slovenia": "EU",
                "Latvia": "EU", "Kosovo": "NON-EU",
                "Canada": "NON-EU", "Cyprus": "EU",
                "Israel": "NON-EU", "Estonia": "EU",
                "Brazil": "NON-EU", "Mexico": "NON-EU",
                "Bulgaria": "EU"
                }


eu_country.each do |key, value|
    if Country.where(:name => key) == []
        puts 'Create EU Country'
        country = Country.where(name: key)[0]
        value == "EU" ? eu = 1 : eu = 0
        country.update(is_eu: eu)
    end
end


project_types = ["VAT", "ESPL", "LSPL", "ANNUAL"]

project_types.each do |project_type|
    if ProjectType.where(:name => project_type) == []
        puts 'Create Project Type'
        project_type_created = ProjectType.new(name: project_type)
        project_type_created.save!
    end
end

periodicities = ["Monthly", "Quarterly", "Yearly"]

periodicities.each do |periodicity|
    if Periodicity.where(:name => periodicity) == []
        puts 'Create Periodicities'
        periodicity_created = Periodicity.new(name: periodicity)
        periodicity_created.save!
    end
end


document_types = ["Invoice", "Credit Note"]

document_types.each do |document_type|
    if DocumentType.where(:name => document_type) == []
        puts 'Create Document Type'
        document_type_new = DocumentType.new(name: document_type)
        document_type_new.save!
    end
end

operation_types = ["Add", "Minus"]

operation_types.each do |operation_type|
    if OperationType.where(:name => operation_type) == []
        puts 'Create Operation Types'
        operation_type_new = OperationType.new(name: operation_type)
        operation_type_new.save!
    end
end


sides_operation = ["Purchase", "Sale"]

sides_operation.each do |sides_operation|
    if TaxCodeOperationSide.where(name: sides_operation) == []
        puts 'Create Side Operation'
        operation_side = TaxCodeOperationSide.new(name: sides_operation)
        operation_side.save!
    end
end

locations_operation = ["Domestic", "Intra-EU", "Outside-EU", "Intra VAT Group"]

locations_operation.each do |location_operation|
    if TaxCodeOperationLocation.where(name: location_operation) == []
        puts 'Create Tax Code Operation Location'
        operation_location = TaxCodeOperationLocation.new(name: location_operation)
        operation_location.save!
    end
end

types_operation = ["Capital Goods", "Commodities & Raw Materials", "Services", "Goods Sold Online", "Various Goods"]

types_operation.each do |type_operation|
    if TaxCodeOperationType.where(name: type_operation) == []
        puts 'Create Tax Code Operation Type'
        operation_type = TaxCodeOperationType.new(name: type_operation)
        operation_type.save!
    end
end


rates_operation = ["Standard", "Intermediate", "Reduced", "Zero", "Exempt"]

rates_operation.each do |rate_operation|
    if TaxCodeOperationRate.where(name: rate_operation) == []
        puts 'Create Tax Code Operation Rate'
        operation_rate = TaxCodeOperationRate.new(name: rate_operation)
        operation_rate.save!
    end
end

@type_of_ticket = {"Food & Drinks" => 5, "Restaurant" => 3, "Internet & Phone" => 3, "Raw Materials" => 2, "Multimedia" => 5, "Transport Services" => 3, "Transport Object" => 5}

@type_of_ticket.each do |ticket, tax_code_operation_type_id|
    if TicketToTaxCode.where(name: ticket) == []
        puts 'Create Ticket to Tax Code'
        @tax_code_operation_type = TaxCodeOperationType.find(tax_code_operation_type_id)
        @ticket_to_tax_code_type = TicketToTaxCode.new(name: ticket, tax_code_operation_type_id: @tax_code_operation_type.id)
        @ticket_to_tax_code_type.save
    end
end


@name_accesses = ["Admin", "Employee", "Accountant"]
@name_accesses.each do |name_access|
    if Access.where(name: name_access) == []
        puts 'Create Accesses'
        access = Access.new(name: name_access)
        access.save
    end
end

# Create Country Tax Code Rate

country_tax_code_rates = CSV.parse(File.read("./storage/country_tax_code_rate.csv"), headers: true)

=begin

country,operation_rate,rate

=end

country_tax_code_rates.each do |row|
    country = Country.where(name: row['country'])[0]
    operation_rate = TaxCodeOperationRate.where(name: row['operation_rate'])[0]
    if CountryRate.where(country_id: country.id, tax_code_operation_rate_id: operation_rate.id) == []
        puts 'Create Country Tax Code Rate'
        country_rate = CountryRate.new(country_id: country.id, tax_code_operation_rate_id: operation_rate.id, rate: row['rate'].to_f)
        country_rate.save!
    end

end


# 'Create Due Date'

due_dates = CSV.parse(File.read("./storage/due_dates.csv"), headers: true)

=begin

country,project_type,periodicity,begin_date,end_date,due_date
Belgium,VAT,Monthly,2021-01-01,2021-01-31,2021-02-22

=end

due_dates.each do |row|
    country = Country.where(name: row['country'])[0]
    project_type = ProjectType.where(name: row['project_type'])[0]
    periodicity = Periodicity.where(name: row['periodicity'])[0]
    if DueDate.where(country_id: country.id, project_type_id: project_type.id, periodicity_id: periodicity.id, begin_date: row['begin_date'], end_date: row['end_date'], due_date: row['due_date']) == []
        puts 'Create Due Date'
        due_date = DueDate.new(country_id: country.id, project_type_id: project_type.id, periodicity_id: periodicity.id, begin_date: row['begin_date'], end_date: row['end_date'], due_date: row['due_date'])
        due_date.save!
    end
end



boxes = CSV.parse(File.read("./storage/Boxes.csv"), headers: true)

# Country,Project,Periodicity,Official_Name
# Belgium,VAT,6,Box 00 - Opérations soumises à un régime particulier


# 'Create Box'

boxes.each do |row|
    country = Country.where(name: row['Country'])[0]
    project = ProjectType.where(name: row['Project'])[0]
    if row['Periodicity'] == '6'
        # then project same for Monthly & Quarterly
        periodicities = Periodicity.where(id: [1,2])
        periodicities.each do |periodicity|
            # Make sure the BoxNameLanguage doesn't already exist   
            if box = Box.where(name: row["Official_Name"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id) == []
                puts 'Create Box'
                box = Box.new(name: row["Official_Name"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)
                box.save!
            end
        end
    else
        periodicity = Periodicity.where(id: row['Periodicity'])[0]
        # Make sure the BoxNameLanguage doesn't already exist   
        if box = Box.where(name: row["Official_Name"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id) == []
            puts 'Create Box'
            box = Box.new(name: row["Official_Name"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)
            box.save!
        end
    end

end

=begin
Box,Country,Project,Periodicity,Language,Name
Box 00 - Opérations soumises à un régime particulier,Belgium,VAT,6,French,Box 00 - Opérations soumises à un régime particulier

=end

# 'Create Box Name Language'

box_name_languages = CSV.parse(File.read("./storage/BoxNameLanguage.csv"), headers: true)

box_name_languages.each do |row|
    country = Country.where(name: row['Country'])[0]
    project = ProjectType.where(name: row['Project'])[0]
    language = Language.where(name: row['Language'])[0]
    
    if row['Periodicity'] == '6'
        # then project same for Monthly & Quarterly
        periodicities = Periodicity.where(id: [1,2])
        periodicities.each do |periodicity|
            box = Box.where(name: row['Box'], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)[0]
            # Make sure the BoxNameLanguage doesn't already exist
            if BoxNameLanguage.where(box_id: box.id, language_id: language.id, name: row['Name']) == []
                puts 'Create Box Name Language'
                box_name_language = BoxNameLanguage.new(box_id: box.id, language_id: language.id, name: row['Name'])
                box_name_language.save!
            end
        end
    else 
        periodicity = Periodicity.where(id: row['Periodicity'])[0]
        box = Box.where(name: row["Box"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)[0]
        # Make sure the BoxNameLanguage doesn't already exist
        if BoxNameLanguage.where(box_id: box.id, language_id: language.id, name: row['Name']) == []
            puts 'Create Box Name Language'
            box_name_language = BoxNameLanguage.new(language_id: language.id, name: row['Name'])
            box_name_language.save!
        end
    end

end

=begin

Box,Country,Project,Periodicity,Type Operation,Side Operation,Location,Standard,Intermediate,Reduced,Zero,Exempt,Document Type,Operation
Box 83 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - biens d’investissement,Belgium,VAT,6,Capital Goods,Purchase,Domestic,1,1,1,1,1,Add,Invoice

=end
# 'Create Box Logic'

box_logic = CSV.parse(File.read("./storage/box_logic.csv"), headers: true)

box_logic.each do |row|
    country = Country.where(name: row['Country'])[0]
    project = ProjectType.where(name: row['Project'])[0]
    operation_type = TaxCodeOperationType.where(name: row["Type Operation"])[0]
    operation_side = TaxCodeOperationSide.where(name: row["Side Operation"])[0]
    operation_location = TaxCodeOperationLocation.where(name: row["Location"])[0]
    document_type = DocumentType.where(name: row['Document Type'])[0]
    operation = OperationType.where(name: row['Operation'])[0]
    rates = []
    # If you have a number in it, the rate needs to be taken into account
    !row['Standard'].nil? ? rates << "Standard" : ''
    !row['Intermediate'].nil? ? rates << "Intermediate" : ''
    !row['Reduced'].nil? ? rates << "Reduced" : ''
    !row['Zero'].nil? ? rates << "Zero" : ''
    !row['Exempt'].nil? ? rates << "Exempt" : ''

    row['Standard'] == '1' || row['Intermediate'] == '1' || row['Reduced'] == '1' || row['Zero'] == '1' || row['Exempt'] == '1' ? amounts_type = "Reporting Currency Taxable Basis" : ''
    row['Standard'] == '2' || row['Intermediate'] == '2' || row['Reduced'] == '2' || row['Zero'] == '2' || row['Exempt'] == '2' ? amounts_type = "Reporting Currency VAT Amount" : ''
    row['Standard'] == '3' || row['Intermediate'] == '3' || row['Reduced'] == '3' || row['Zero'] == '3' || row['Exempt'] == '3' ? amounts_type = "Reporting Currency Gross Amount" : ''

    amount = Amount.where(name: amounts_type)[0]

    operation_rates = TaxCodeOperationRate.where(name: rates)

    if row['Periodicity'] == '6'
        # then project same for Monthly & Quarterly
        periodicities = Periodicity.where(id: [1,2])
        periodicities.each do |periodicity|
            box = Box.where(name: row["Box"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)[0]
            operation_rates.each do |operation_rate|

                if box_logic_created = BoxLogic.where(box_id: box.id, tax_code_operation_type_id: operation_type.id, tax_code_operation_side_id: operation_side.id, tax_code_operation_location_id: operation_location.id, tax_code_operation_rate_id: operation_rate.id, operation_type_id: operation.id, document_type_id: document_type.id, amount_id: amount.id) == []
                    puts 'Create Box Name Language'

                    box_logic_created = BoxLogic.new(box_id: box.id, tax_code_operation_type_id: operation_type.id, tax_code_operation_side_id: operation_side.id, tax_code_operation_location_id: operation_location.id, tax_code_operation_rate_id: operation_rate.id, operation_type_id: operation.id, document_type_id: document_type.id, amount_id: amount.id)
                    
                    box_logic_created.save!
                end
            end
        end

    else
        periodicity = Periodicity.where(id: row['Periodicity'])[0]
        box = Box.where(name: row["Box"], country_id: country.id, project_type_id: project.id, periodicity_id: periodicity.id)[0]

        operation_rates.each do |operation_rate|
            tax_code_operation_rate = TaxCodeOperationRate.where(name: operation_rate)[0]
            if box_logic_created = BoxLogic.where(box_id: box.id, tax_code_operation_type_id: operation_type.id, tax_code_operation_side_id: operation_side.id, tax_code_operation_location_id: operation_location.id, tax_code_operation_rate_id: operation_type.id, operation_type_id: operation.id, document_type_id: document_type.id, amount_id: amount.id) == []

                puts 'Create Box Name Language'
                box_logic_created = BoxLogic.new(box_id: box.id, tax_code_operation_type_id: operation_type.id, tax_code_operation_side_id: operation_side.id, tax_code_operation_location_id: operation_location.id, tax_code_operation_rate_id: tax_code_operation_rate.id, operation_type_id: operation.id, document_type_id: document_type.id)
                box_logic_created.save!
            end
        end
    end

end


=begin

country,tax_code_operation_side,tax_code_operation_location,tax_code_operation_type,tax_code_operation_rate

=end

# 'Create Country Tax Code'

country_tax_codes = CSV.parse(File.read("./storage/country_tax_code.csv"), headers: true)


country_tax_codes.each do |row|
    country = Country.where(name: row['country'])[0]
    tax_code_operation_side = TaxCodeOperationSide.where(name: row['tax_code_operation_side'])[0]
    tax_code_operation_location = TaxCodeOperationLocation.where(name: row['tax_code_operation_location'])[0]
    tax_code_operation_type = TaxCodeOperationType.where(name: row['tax_code_operation_type'])[0]
    tax_code_operation_rate = TaxCodeOperationRate.where(name: row['tax_code_operation_rate'])[0]
    if CountryTaxCode.where(country_id: country.id, tax_code_operation_location_id: tax_code_operation_location.id, tax_code_operation_side_id: tax_code_operation_side.id, tax_code_operation_type_id: tax_code_operation_type.id, tax_code_operation_rate_id: tax_code_operation_rate.id) == []
        puts 'Create Country Tax Code'

        country_tax_code = CountryTaxCode.new(country_id: country.id, tax_code_operation_location_id: tax_code_operation_location.id, tax_code_operation_side_id: tax_code_operation_side.id, tax_code_operation_type_id: tax_code_operation_type.id, tax_code_operation_rate_id: tax_code_operation_rate.id)
        country_tax_code.save!
    end
end
