defmodule Monkeynote.Repo do
  use Ecto.Repo,
    otp_app: :monkeynote,
    adapter: Ecto.Adapters.Postgres
end
