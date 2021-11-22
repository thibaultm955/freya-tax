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

language_country = {"Belgium": {'1': "Belgium", '2': "Belgique"}, "France": {"1": "France", "2": "France"},
                    "Australia": {'1': "Australia", '2': "Australie"}, "Czech Republic": {"1": "Czech Republic", "2": "République tchèque"},
                    "Finland": {'1': "Finland", '2': "Finlande"}, "Germany": {"1": "Germany", "2": "Allemagne"},
                    "Italy": {'1': "Italy", '2': "Italie"}, "Luxembourg": {"1": "Luxembourg", "2": "Luxembourg"},
                    "Netherlands": {'1': "Netherlands", '2': "Pays-Bas"}, "Norway": {"1": "Norway", "2": "Norvège"},
                    "Portugal": {'1': "Portugal", '2': "Portugal"}, "Spain": {"1": "Spain", "2": "Espagne"},
                    "Sweden": {'1': "Sweden", '2': "Suède"}, "Switzerland": {"1": "Switzerland", "2": "Suisse"},
                    "United Kingdom": {'1': "United Kingdom", '2': "Royaume-Uni"}, "United States": {"1": "United States", "2": "Etats-Unis d'Amérique"},
                    "Russia": {'1': "Russia", '2': "Russie"}, "Turkey": {"1": "Turkey", "2": "Turquie"},
                    "Ukraine": {'1': "Ukraine", '2': "Ukraine"}, "Poland": {"1": "Poland", "2": "Pologne"},
                    "Romania": {'1': "Romania", '2': "Roumanie"}, "Kazakhstan": {"1": "Kazakhstan", "2": "Kazakhstan"},
                    "Greece": {'1': "Greece", '2': "Grèce"}, "Azerbaijan": {"1": "Azerbaijan", "2": "Azerbaïdjan"},
                    "Hungary": {'1': "Hungary", '2': "Hongrie"}, "Belarus": {"1": "Belarus", "2": "Biélorussie"},
                    "Austria": {'1': "Austria", '2': "Autriche"}, "Serbia": {"1": "Serbia", "2": "Serbie"},
                    "Denmark": {'1': "Denmark", '2': "Danemark"}, "Slovakia": {"1": "Slovakia", "2": "Slovaquie"},
                    "Ireland": {'1': "Ireland", '2': "Irlande"}, "Croatia": {"1": "Croatia", "2": "Croatie"},
                    "Georgia": {'1': "Georgia", '2': "Géorgie"}, "Bosnia and Herzegovina": {"1": "Bosnia and Herzegovina", "2": "Bosnie-Herzégovine"},
                    "Armenia": {'1': "Armenia", '2': "Arménie"}, "Albania": {"1": "Albania", "2": "Albanie"},
                    "Lithuania": {'1': "Lithuania", '2': "Lituanie"}, "Moldova": {"1": "Moldova", "2": "Moldavie"},
                    "North Macedonia": {'1': "North Macedonia", '2': "Macédoine du Nord"}, "Slovenia": {"1": "Slovenia", "2": "Slovénie"},
                    "Latvia": {'1': "Latvia", '2': "Lettonie"}, "Kosovo": {"1": "Kosovo", "2": "Kosovo"},
                    "Canada": {'1': "Canada", '2': "Canada"}, "Cyprus": {"1": "Cyprus", "2": "Chypre"},
                    "Israel": {'1': "Israel", '2': "Israel"}, "Estonia": {"1": "Estonia", "2": "Estonie"},
                    "Brazil": {'1': "Brazil", '2': "Brésil"}, "Mexico": {"1": "Mexico", "2": "Mexique"},
                    "Bulgaria": {'1': "Bulgaria", '2': "Bulgarie"}
                    }

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


language_country.each do |key, value|
    value.each do |language_id, name|
        country = Country.where(name: key)[0]
        p country
        if LanguageCountry.where(name: name) == []
            # need to_s.to_i because it is a symbol
            language_country_save = LanguageCountry.new(name: name, language_id: language_id.to_s.to_i, country_id: country.id)
            language_country_save.save!
            p language_country_save
        end
    end
end

eu_country.each do |key, value|
    # if Country.where(:name => country) == []
        country = Country.where(name: key)[0]
        value == "EU" ? eu = 1 : eu = 0
        country.update(is_eu: eu)
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

due_date = DueDate.new(begin_date: '2021-09-01', end_date: '2021-12-31', periodicity_to_project_type_id: '2', due_date: '2022-01-20')
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
    "Box 85 - Montant des notes de crédit reçues et des corrections négatives - relatif aux autres opérations du cadre III",
    "Box 86 - Acquisitions intracommunautaires effectuées en Belgique et ventes ABC",
    "Box 87 - Autres opérations à l’entrée pour lesquelles la TVA est due par le déclarant",
    "Box 88 - Services intracommunautaires avec report de perception",
    "TVA",
    "Box 54 - TVA relative aux opérations déclarées en grilles 01, 02 et 03",
    "Box 55-  TVA relative aux opérations déclarées en grilles 86 et 88",
    "Box 56 - TVA relative aux opérations déclarées en grille 87, à l’exception des importations avec report de perception",
    "Box 57 - TVA relative aux importations avec report de perception",
    "Box 61 - Diverses régularisations TVA en faveur de l’Etat",
    "Box 63 - TVA à reverser mentionnée sur les notes de crédit reçues",
    "Box 65 - A ne pas compléter",
    "Box XX - Total des grilles 54, 55, 56, 57, 61 et 63",
    "Box 59 - TVA déductible",
    "Box 62 - Diverses régularisations TVA en faveur du déclarant",
    "Box 64 - TVA à récupérer mentionnée sur les notes de crédit délivrées",
    "Box 66 - A ne pas compléter",
    "Box YY - Total des grilles 59, 62 et 64",
    "Sommes",
    "Box 71 - Taxe due à l’Etat",
    "Box 72 - Sommes dues par l’Etat",
    "Box 91 - Concerne uniquement la déclaration mensuelle de décembre TVA réellement due pour la période du 1er au 20 décembre",
    ]
}

box_names.each do |return_information, names|
    puts return_information
    names.each do |name|
        country = Country.where(name: return_information[0])[0]
        project_type = ProjectType.where(name: return_information[1])[0]
        periodicity = Periodicity.where(name: return_information[2])[0]
        language = Language.where(name: return_information[3])[0]
        # puts language
        # puts project_type

        periodicty_to_project_type = PeriodicityToProjectType.where(country_id: country.id, project_type_id: project_type.id, periodicity_id: periodicity.id)[0]
        # puts periodicty_to_project_type

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

box_logics = {"Box 00 - Opérations soumises à un régime particulier" => 
                [ 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"] , 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"] , 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Zero", "Reporting Currency Taxable Basis"],
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Services", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Goods Sold Online", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Various Goods", "Zero", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Services", "Exempt", "Reporting Currency Taxable Basis"], 
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Goods Sold Online", "Exempt", "Reporting Currency Taxable Basis"] ,
                    ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra VAT Group", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"]
                ], 
            "Box 01 - Opérations pour lesquelles la TVA est due par le déclarant - 6%" => 
            [  
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency Taxable Basis"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency Taxable Basis"]
            ] ,
            "Box 02 - Opérations pour lesquelles la TVA est due par le déclarant - 12%" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency Taxable Basis"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency Taxable Basis"]
            ],
            "Box 03 - Opérations pour lesquelles la TVA est due par le déclarant - 21%" =>
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency Taxable Basis"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency Taxable Basis"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency Taxable Basis"]
            ],
            "Box 44 - Services pour lesquels la TVA étrangère est due par le cocontractant" =>
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Basis"]        
            ],
            # "Box 45 - Opérations pour lesquelles la TVA est due par le cocontractant" => [ [] ],
            "Box 46 - Livraisons intracommunautaires exemptées effectuées en Belgique et ventes ABC" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"] ,    
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"] ,
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Basis"]
            ],
            "Box 47 - Autres opérations exemptées et autres opérations effectuées à l’étranger" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Intra-EU", "Goods Sold Online", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Outside-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Outside-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Outside-EU", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Outside-EU", "Goods Sold Online", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Outside-EU", "Various Goods", "Zero", "Reporting Currency Taxable Basis"]
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
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"]
            ],
            "Box 82 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - services et biens divers" =>
            [
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Various Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Various Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"]

            ],
            "Box 83 - Montant des opérations à l’entrée compte tenu des notes de crédit reçues et autres corrections - biens d’investissement" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"]
            ],
            # "Box 84 - Montant des notes de crédit reçues et des corrections négatives - relatif aux opérations inscrites en grilles 86 et 88",
            #"Box 85 - Montant des notes de crédit reçues et des corrections négatives - relatif aux autres opérations du cadre III",
            "Box 86 - Acquisitions intracommunautaires effectuées en Belgique et ventes ABC" =>
            [
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Commodities & Raw Materials", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Various Goods", "Exempt", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Zero", "Reporting Currency Taxable Basis"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Capital Goods", "Exempt", "Reporting Currency Taxable Basis"]
            ],
            # "Box 87 - Autres opérations à l’entrée pour lesquelles la TVA est due par le déclarant",
            # "Box 88 - Services intracommunautaires avec report de perception",
            # <h2>TVA</h2>
            "Box 54 - TVA relative aux opérations déclarées en grilles 01, 02 et 03" =>
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"]
            ],
            # "Box 55-  TVA relative aux opérations déclarées en grilles 86 et 88",
            # "Box 56 - TVA relative aux opérations déclarées en grille 87, à l’exception des importations avec report de perception",
            # "Box 57 - TVA relative aux importations avec report de perception ",
            # "Box 61 - Diverses régularisations TVA en faveur de l’Etat",
            # "Box 63 - TVA à reverser mentionnée sur les notes de crédit reçues",
            # "Box 65 - A ne pas compléter",
            "Box XX - Total des grilles 54, 55, 56, 57, 61 et 63" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"] , 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"], 
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Goods Sold Online", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Sale", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"]
            ],
            "Box 59 - TVA déductible" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"]
            ],
            # "Box 62 - Diverses régularisations TVA en faveur du déclarant",
            # "Box 64 - TVA à récupérer mentionnée sur les notes de crédit délivrées",
            # "Box 66 - A ne pas compléter",
            "Box YY - Total des grilles 59, 62 et 64" => 
            [
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Commodities & Raw Materials", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Various Goods", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Outside-EU", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Intra VAT Group", "Services", "Reduced", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Standard", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Intermediate", "Reporting Currency VAT Amount"],
                ["Belgium", "French", "VAT", "Monthly", "Purchase", "Domestic", "Capital Goods", "Reduced", "Reporting Currency VAT Amount"]
            ],
            # <h2>Sommes</h2>
            # "Box 71 - Taxe due à l’Etat",
            # "Box 72 - Sommes dues par l’Etat",
            # "Box 91 - Concerne uniquement la déclaration mensuelle de décembre TVA réellement due pour la période du 1er au 20 décembre",

}

box_logics.each do |box_name_description, box_logics|
    
    box_logics.each do |box_logic|
        country = Country.where(name: box_logic[0])[0]
        language = Language.where(name: box_logic[1])[0]
        project_type = ProjectType.where(name: box_logic[2])[0]
        periodicity = Periodicity.where(name: box_logic[3])[0]
        periodicty_to_project_type = PeriodicityToProjectType.where(country_id: country.id, project_type_id: project_type.id, periodicity_id: periodicity.id)[0]
        box_name = BoxName.where(name: box_name_description, language_id: language.id, periodicity_to_project_type_id: periodicty_to_project_type.id)[0]
        tax_code_operation_side = TaxCodeOperationSide.where(name: box_logic[4])[0]
        tax_code_operation_location = TaxCodeOperationLocation.where(name: box_logic[5])[0]
        tax_code_operation_type = TaxCodeOperationType.where(name: box_logic[6])[0]
        tax_code_operation_rate = TaxCodeOperationRate.where(name: box_logic[7])[0]
        amount = Amount.where(name: box_logic[8])[0]

        puts box_name.name
        puts tax_code_operation_side.name
        puts tax_code_operation_location.name
        puts tax_code_operation_type.name
        puts tax_code_operation_rate.name
        puts amount.name


        if BoxInformation.where(box_name_id: box_name.id, amount_id: amount.id, tax_code_operation_location_id: tax_code_operation_location.id, tax_code_operation_rate_id: tax_code_operation_rate.id, tax_code_operation_side_id: tax_code_operation_side.id, tax_code_operation_type_id: tax_code_operation_type.id) == []
            box_information = BoxInformation.new(box_name_id: box_name.id, amount_id: amount.id, tax_code_operation_location_id: tax_code_operation_location.id, tax_code_operation_rate_id: tax_code_operation_rate.id, tax_code_operation_side_id: tax_code_operation_side.id, tax_code_operation_type_id: tax_code_operation_type.id)
            puts box_information
            box_information.save!
        end
    end
end

