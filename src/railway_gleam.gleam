import gleam/bytes_builder
import gleam/erlang/os
import gleam/erlang/process
import gleam/http/response
import gleam/int
import gleam/result.{flatten, lazy_unwrap, map}
import mist

pub fn main() {
  let port =
    lazy_unwrap(
      map(over: os.get_env("PORT"), with: int.base_parse(_, 10))
        |> flatten,
      fn() { 8080 },
    )

  let assert Ok(_) =
    fn(_req) {
      response.new(200)
      |> response.set_body(
        mist.Bytes(bytes_builder.from_string("hello, world!")),
      )
    }
    |> mist.new
    |> mist.port(port)
    |> mist.start_http
  process.sleep_forever()
}
