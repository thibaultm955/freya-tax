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
        country_created.save
    end
end

project_types = ["VAT", "ESPL", "LSPL", "ANNUAL"]

project_types.each do |project_type|
    if ProjectType.where(:name => project_type) == []
        project_type_created = ProjectType.new(name: project_type)
        project_type_created.save
    end
end

periodicities = ["Monthly", "Quarterly", "Yearly"]

periodicities.each do |periodicity|
    if Periodicity.where(:name => periodicity) == []
        periodicity_created = Periodicity.new(name: periodicity)
        periodicity_created.save
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
                periodicty_to_project_type.save
            end
        end
    end
end

due_date = DueDate.new(begin_date: '2021-02-01', end_date: '2021-02-28', periodicity_to_project_type_id: '1', due_date: '2021-03-20')
due_date.save

sides_operation = ["AP", "AR"]

sides_operation.each do |sides_operation|
    operation_side = TaxCodeOperationSide.new(name: sides_operation)
    operation_side.save
end

locations_operation = ["Domestic", "Intra-EU", "Outside-EU", "Intra VAT Group"]

locations_operation.each do |location_operation|
    operation_location = TaxCodeOperationLocation.new(name: location_operation)
    operation_location.save
end

types_operation = ["Capital Goods","Trade Goods & Raw Materials", "Services & Various Goods", "Goods Sold Online"]

types_operation.each do |type_operation|
    operation_type = TaxCodeOperationType.new(name: type_operation)
    operation_type.save
end


rates_operation = ["Standard", "Intermediate", "Reduced", "Zero", "Exempt"]

rates_operation.each do |rate_operation|
    operation_rate = TaxCodeOperationRate.new(name: rate_operation)
    operation_rate.save
end

country_tax_code = CountryTaxCode.new(country_id: 2, tax_code_operation_location_id: 2, tax_code_operation_side_id: 1, tax_code_operation_type_id: 4, tax_code_operation_rate_id: 1)
country_tax_code.save
code = CountryTaxCode.new(country_id: 2, tax_code_operation_location_id: 1, tax_code_operation_side_id: 1, tax_code_operation_type_id: 4, tax_code_operation_rate_id: 1)
code.save
