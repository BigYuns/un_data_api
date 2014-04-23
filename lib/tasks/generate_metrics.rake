require "#{Rails.root}/lib/modules/generate_metrics.rb"

namespace :metrics do
  desc "automatically populate metrics"
  task generate_metrics: :environment do
    gen_metrics = GenerateMetrics.new
    gen_metrics.get_service_id
    gen_metrics.get_metric_list
    gen_metrics.create_metrics
  end

  desc "automatically populate methods metrics if some already exist"
  task add_metrics: :environment do
    add_metrics = AddMetrics.new
    add_metrics.get_service_id
    add_metrics.get_metric_list
    add_metrics.create_metrics
  end
end