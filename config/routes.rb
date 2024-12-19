Rails.application.routes.draw do
  root "forecasts#index"

  get '/', to: 'forecasts#index', as: :forecasts
end
