defmodule ForksTheEggSample.Accounts.Message do
  @moduledoc """
  Module to send messages, by email or phone, to the user.
  """

  import Bamboo.Email
  alias ForksTheEggSample.Mailer

  @doc """
  An email with a confirmation link in it.
  """
  def confirm_request(address, key) do
    prep_mail(address)
    |> subject("Confirm your account - ForksTheEggSample Example")
    |> text_body("Confirm your ForksTheEggSample Example email here http://www.example.com/confirm?key=#{key}")
    |> Mailer.deliver_now
  end

  @doc """
  An email with a link to reset the password.
  """
  def reset_request(address, nil) do
    prep_mail(address)
    |> subject("Reset your password - ForksTheEggSample Example")
    |> text_body("You requested a password reset, but no user is associated with the email you provided.")
    |> Mailer.deliver_now
  end
  def reset_request(address, key) do
    prep_mail(address)
    |> subject("Reset your password - ForksTheEggSample Example")
    |> text_body("Reset your password at http://www.example.com/password_resets/edit?key=#{key}")
    |> Mailer.deliver_now
  end

  @doc """
  An email acknowledging that the account has been successfully confirmed.
  """
  def confirm_success(address) do
    prep_mail(address)
    |> subject("Confirmed account - ForksTheEggSample Example")
    |> text_body("Your account has been confirmed.")
    |> Mailer.deliver_now
  end

  @doc """
  An email acknowledging that the password has been successfully reset.
  """
  def reset_success(address) do
    prep_mail(address)
    |> subject("Password reset - ForksTheEggSample Example")
    |> text_body("Your password has been reset.")
    |> Mailer.deliver_now
  end

  defp prep_mail(address) do
    new_email()
    |> to(address)
    |> from("forks_the_egg_sample@example.com")
  end
end
