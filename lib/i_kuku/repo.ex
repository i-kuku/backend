defmodule IKuku.Repo do
  use Ecto.Repo,
    otp_app: :i_kuku,
    adapter: Ecto.Adapters.Postgres
end
