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

country_projecttype_periodicity = {"Belgium" => {"VAT" => ["Monthly", "Quarterly", "Yearly"]}}

country_projecttype_periodicity.each do |country_name, values|
    country = Country.where(name: country_name)[0]
    values.each do |project_type, periodicities|
        type = ProjectType.where(name: project_type)[0]
        periodicities.each do |periodicity|
            period = Periodicity.where(name: periodicity)[0]
            if PeriodictyToProjectType.where(country_id: country.id, project_type_id: type.id, periodicity_id: period.id) == []
                periodicty_to_project_type = PeriodictyToProjectType.new()
                periodicty_to_project_type.project_type = type
                periodicty_to_project_type.periodicity = period
                periodicty_to_project_type.country = country
                periodicty_to_project_type.save
            end
        end
    end
end
