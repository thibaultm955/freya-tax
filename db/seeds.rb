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

countries.each do |country|
    if Country.where(:name => country) == []
        country_created = Country.new(name: country)
        country_created.save!
    end
end

project_types = ["VAT", "ESPL", "LSPL", "ANNUAL"]

project_types.each do |project_type|
    if ProjectType.where(:name => project_type) == []
        project_type_created = ProjectType.new(name: project_type)
        project_type_created.save!
    end
end

periodicities = ["Monthly", "Quarterly", "Yearly"]

periodicities.each do |periodicity|
    if Periodicity.where(:name => periodicity) == []
        periodicity_created = Periodicity.new(name: periodicity)
        periodicity_created.save!
    end
end


country_projecttype_periodicity = {"Belgium" => {"VAT" => ["Monthly", "Quarterly", "Yearly"], "LSPL" => ["Monthly", "Quarterly", "Yearly"]}}

country_projecttype_periodicity.each do |country_name, values|
    country = Country.where(name: country_name)[0]
    values.each do |project_type, periodicities|
        type = ProjectType.where(name: project_type)[0]
        periodicities.each do |periodicity|
            period = Periodicity.where(name: periodicity)[0]
            if PeriodicityToProjectType.where(country_id: country.id, project_type_id: type.id, periodicity_id: period.id) == []
                periodicty_to_project_type = PeriodicityToProjectType.new()
                periodicty_to_project_type.project_type = type
                periodicty_to_project_type.periodicity = period
                periodicty_to_project_type.country = country
                periodicty_to_project_type.save!
            end
        end
    end
end

due_date = DueDate.new(begin_date: '2021-02-01', end_date: '2021-02-28', periodicity_to_project_type_id: '1', due_date: '2021-03-20')
due_date.save

=begin
Déclarations trimestrielles

Déclaration relative au...	A rentrer au plus tard pour le...
1er trimestre 2021	20.04.2021
2e trimestre 2021	10.08.2021 (1)
3e trimestre 2021	20.10.2021
4e trimestre 2021	20.01.2022

Déclarations mensuelles

Déclaration relative au...	A rentrer au plus tard pour le...
Décembre 2020	20.01.2021
Janvier 2021	22.02.2021
Février 2021	22.03.2021
Mars 2021	20.04.2021
Avril 2021	20.05.2021
Mai 2021	21.06.2021
Juin 2021	10.08.2021 (1) (2)
Juillet 2021	10.09.2021 (1) (2)
Août 2021	20.09.2021
Septembre 2021	20.10.2021
Octobre 2021	22.11.2021
Novembre 2021	20.12.2021
Décembre 2021	20.01.2021
=end

sides_operation = ["Purchase", "Sale"]

sides_operation.each do |sides_operation|
    if TaxCodeOperationSide.where(name: sides_operation) == []
        operation_side = TaxCodeOperationSide.new(name: sides_operation)
        operation_side.save!
    end
end

locations_operation = ["Domestic", "Intra-EU", "Outside-EU", "Intra VAT Group"]

locations_operation.each do |location_operation|
    if TaxCodeOperationLocation.where(name: location_operation) == []
        operation_location = TaxCodeOperationLocation.new(name: location_operation)
        operation_location.save!
    end
end

types_operation = ["Capital Goods", "Commodities & Raw Materials", "Services", "Goods Sold Online", "Various Goods"]

types_operation.each do |type_operation|
    if TaxCodeOperationType.where(name: type_operation) == []
        operation_type = TaxCodeOperationType.new(name: type_operation)
        operation_type.save!
    end
end


rates_operation = ["Standard", "Intermediate", "Reduced", "Zero", "Exempt"]

rates_operation.each do |rate_operation|
    if TaxCodeOperationRate.where(name: rate_operation) == []
        operation_rate = TaxCodeOperationRate.new(name: rate_operation)
        operation_rate.save!
    end
end



sides = TaxCodeOperationSide.all
locations = TaxCodeOperationLocation.all
types = TaxCodeOperationType.all
rates = TaxCodeOperationRate.all

sides.each do |side|
    locations.each do |location|
        types.each do |type|
            rates.each do |rate|
                if CountryTaxCode.where(country_id: 2, tax_code_operation_location_id: location.id, tax_code_operation_side_id: side.id, tax_code_operation_type_id: type.id, tax_code_operation_rate_id: rate.id) == []
                    country_tax_code = CountryTaxCode.new(country_id: 2, tax_code_operation_location_id: location.id, tax_code_operation_side_id: side.id, tax_code_operation_type_id: type.id, tax_code_operation_rate_id: rate.id)
                    country_tax_code.save!
                end
            end
        end
    end
end


# Languages
languages = ["English", "French"]
languages.each do |language|
    if Language.where(name:language) == []
        model_language = Language.new(name:language)
        model_language.save!
    end
end

# Amounts

amounts = [ "Reporting Currency Gross Amount", "Reporting Currency Taxable Basis", "Reporting Currency VAT Amount"]
amounts.each do |amount|
    if Amount.where(name: amount) == []
        amount_name = Amount.new(name: amount)
        amount_name.save!
    end
end

# Return Box for Belgium

# Box Name Belgium
box_names = {["Belgium", "VAT", "Monthly", "French"] => [
    "Box 00 - Opérations soumises à un régime particulier",
    "Box 01 - Opérations pour lesquelles la TVA est due par le déclarant - 6%",
    "Box 02 - Opérations pour lesquelles la TVA est due par le déclarant - 12%",
    "Box 03 - Opérations pour lesquelles la TVA est due par le déclarant - 21%",
    "Box 44 - Services pour lesquels la TVA étrangère est due par le cocontractant",
    "Box 45 - Opérations pour lesquelles la TVA est due par le cocontractant",
    "Box 46 - Livraisons intracommunautaires exemptées effectuées en Belgique et ventes ABC",
    "Box 47 - Autres opérations exemptées et autres opérations effectuées à l’étranger",
    "Box 48 - Montant des notes de crédit délivrées et des corrections négatives - relatif aux opérations inscrites en grilles 44 et 46",
    "Box 49 - Montant des notes de crédit délivrées et des corrections négatives - relatif aux autres opérations du cadre II",
    "Achats",
    "Box 81 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - marchandises, matières premières et matières auxiliaires",
    "Box 82 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - services et biens divers",
    "Box 83 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - biens d’investissement",
    "Box 84 - Montant des notes de crédit reçues et des corrections négatives - relatif aux opérations inscrites en grilles 86 et 88 ",
    "Box 85 - Montant des notes de crédit reçues et des corrections négatives - relatif aux autres opérations du cadre III ",
    "Box 86 - Acquisitions intracommunautaires effectuées en Belgique et ventes ABC ",
    "Box 87 - Autres opérations à l’entrée pour lesquelles la TVA est due par le déclarant ",
    "Box 88 - Services intracommunautaires avec report de perception ",
    "TVA",
    "Box 54 - TVA relative aux opérations déclarées en grilles 01, 02 et 03 ",
    "Box 55-  TVA relative aux opérations déclarées en grilles 86 et 88 ",
    "Box 56 - TVA relative aux opérations déclarées en grille 87, à l’exception des importations avec report de perception",
    "Box 57 - TVA relative aux importations avec report de perception ",
    "Box 61 - Diverses régularisations TVA en faveur de l’Etat ",
    "Box 63 - TVA à reverser mentionnée sur les notes de crédit reçues ",
    "Box 65 - A ne pas compléter",
    "Box XX - Total des grilles 54, 55, 56, 57, 61 et 63",
    "Box 59 - TVA déductible ",
    "Box 62 - Diverses régularisations TVA en faveur du déclarant  ",
    "Box 64 - TVA à récupérer mentionnée sur les notes de crédit délivrées",
    "Box 66 - A ne pas compléter",
    "Box YY - Total des grilles 59, 62 et 64",
    "Sommes",
    "Box 71 - Taxe due à l’Etat",
    "Box 72 - Sommes dues par l’Etat  ",
    "Box 91 - Concerne uniquement la déclaration mensuelle de décembre TVA réellement due pour la période du 1er au 20 décembre  ",
    ]
}

box_names.each do |return_information, names|
    puts return_information
    names.each do |name|
        country = Country.where(name: return_information[0])[0]
        project_type = ProjectType.where(name: return_information[1])[0]
        periodicity = Periodicity.where(name: return_information[2])[0]
        language = Language.where(name: return_information[3])[0]
        puts language
        puts project_type

        periodicty_to_project_type = PeriodicityToProjectType.where(country_id: country.id, project_type_id: project_type.id, periodicity_id: periodicity.id)[0]
        puts periodicty_to_project_type

        if BoxName.where(name: name, language_id: language.id, periodicity_to_project_type_id: periodicty_to_project_type.id) == []
            box_name = BoxName.new(name: name, language_id: language.id, periodicity_to_project_type_id: periodicty_to_project_type.id)
            box_name.save!
        end
    end
end

# sides_operation = ["Purchase", "Sale"]
# locations_operation = ["Domestic", "Intra-EU", "Outside-EU", "Intra VAT Group"]
# types_operation = ["Capital Goods", "Commodities & Raw Materials", "Services", "Goods Sold Online", "Various Goods"]
# rates_operation = ["Standard", "Intermediate", "Reduced", "Zero", "Exempt"]

#Box Information

box_name = {"Box 00 - Opérations soumises à un régime particulier" => 
            [ 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Zero", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Capital Goods", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Services", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Goods Sold Online", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Various Goods", "Zero", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Services", "Exempt", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Goods Sold Online", "Exempt", "Reporting Currency Taxable Base"] ,
                ["Belgium", "VAT", "Monthly", "Sale", "Intra VAT Group", "Various Goods", "Exempt", "Reporting Currency Taxable Base"]
            ], 
            "Box 01 - Opérations pour lesquelles la TVA est due par le déclarant - 6%" => 
            [  
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency Taxable Base"]
            ] ,
            "Box 02 - Opérations pour lesquelles la TVA est due par le déclarant - 12%" => 
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency Taxable Base"]
            ],
            "Box 03 - Opérations pour lesquelles la TVA est due par le déclarant - 21%" =>
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency Taxable Base"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency Taxable Base"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency Taxable Base"]
            ],
            "Box 44 - Services pour lesquels la TVA étrangère est due par le cocontractant" =>
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Base"]        
            ],
            # "Box 45 - Opérations pour lesquelles la TVA est due par le cocontractant" => [ [] ],
            "Box 46 - Livraisons intracommunautaires exemptées effectuées en Belgique et ventes ABC" => 
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Base"] ,    
                ["Belgium", "VAT", "Monthly", "Sale", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"] ,
                ["Belgium", "VAT", "Monthly", "Sale", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Base"]
            ],
            "Box 47 - Autres opérations exemptées et autres opérations effectuées à l’étranger" => 
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Intra-EU", "Goods Sold Online", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Outside-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Outside-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Outside-EU", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Outside-EU", "Goods Sold Online", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Sale", "Outside-EU", "Various Goods", "Zero", "Reporting Currency Taxable Base"]
            ],
            # "Box 48 - Montant des notes de crédit délivrées et des corrections négatives - relatif aux opérations inscrites en grilles 44 et 46",
            # "Box 49 - Montant des notes de crédit délivrées et des corrections négatives - relatif aux autres opérations du cadre II",
            # <h2>Achats</h2>

# sides_operation = ["Purchase", "Sale"]
# locations_operation = ["Domestic", "Intra-EU", "Outside-EU", "Intra VAT Group"]
# types_operation = ["Capital Goods", "Commodities & Raw Materials", "Services", "Goods Sold Online", "Various Goods"]
# rates_operation = ["Standard", "Intermediate", "Reduced", "Zero", "Exempt"]

            "Box 81 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - marchandises, matières premières et matières auxiliaires" => 
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"]
            ],
            "Box 82 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - services et biens divers" =>
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Various Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Various Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Various Goods", "Exempt", "Reporting Currency Taxable Base"]

            ],
            "Box 83 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - biens d’investissement" => 
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"]
            ],
            # "Box 84 - Montant des notes de crédit reçues et des corrections négatives - relatif aux opérations inscrites en grilles 86 et 88",
            #"Box 85 - Montant des notes de crédit reçues et des corrections négatives - relatif aux autres opérations du cadre III",
            "Box 86 - Acquisitions intracommunautaires effectuées en Belgique et ventes ABC" =>
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Exempt Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Base"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Base"]
            ],
            # "Box 87 - Autres opérations à l’entrée pour lesquelles la TVA est due par le déclarant",
            # "Box 88 - Services intracommunautaires avec report de perception",
            # <h2>TVA</h2>
            "Box 54 - TVA relative aux opérations déclarées en grilles 01, 02 et 03" =>
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"]
            ],
            # "Box 55-  TVA relative aux opérations déclarées en grilles 86 et 88",
            # "Box 56 - TVA relative aux opérations déclarées en grille 87, à l’exception des importations avec report de perception",
            # "Box 57 - TVA relative aux importations avec report de perception ",
            # "Box 61 - Diverses régularisations TVA en faveur de l’Etat",
            # "Box 63 - TVA à reverser mentionnée sur les notes de crédit reçues",
            # "Box 65 - A ne pas compléter",
            "Box XX - Total des grilles 54, 55, 56, 57, 61 et 63" => 
            [
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"], 
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"]
            ],
            "Box 59 - TVA déductible" => 
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"]
            ],
            # "Box 62 - Diverses régularisations TVA en faveur du déclarant",
            # "Box 64 - TVA à récupérer mentionnée sur les notes de crédit délivrées",
            # "Box 66 - A ne pas compléter",
            "Box YY - Total des grilles 59, 62 et 64" => 
            [
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"]
            ],
            # <h2>Sommes</h2>
            # "Box 71 - Taxe due à l’Etat",
            # "Box 72 - Sommes dues par l’Etat",
            # "Box 91 - Concerne uniquement la déclaration mensuelle de décembre TVA réellement due pour la période du 1er au 20 décembre",

}
