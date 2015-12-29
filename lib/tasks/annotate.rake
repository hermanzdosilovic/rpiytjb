namespace :annotate do
  desc 'Annotate only models'
  task :models do
    `annotate --exclude tests,fixtures,factories,serializers`
  end
end
