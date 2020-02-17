namespace :streets do
  desc "Calculate distances to retailers"
  task calculate_distances: :environment do
    Street.calculate_all_distances!
  end
end
