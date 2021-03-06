## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at https://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2019 Pivotal Software, Inc.  All rights reserved.


defmodule PingCommandTest do
  use ExUnit.Case, async: false
  import TestHelper

  @command RabbitMQ.CLI.Ctl.Commands.PingCommand

  setup_all do
    RabbitMQ.CLI.Core.Distribution.start()

    reset_vm_memory_high_watermark()

    on_exit([], fn ->
      reset_vm_memory_high_watermark()
    end)

    :ok
  end

  setup do
    {:ok, opts: %{node: get_rabbit_hostname(), timeout: 70000}}
  end

  test "validate: with extra arguments returns an arg count error", context do
    assert @command.validate(["extra"], context[:opts]) == {:validation_failure, :too_many_args}
  end

  test "validate: with no arguments succeeds", _context do
    assert @command.validate([], []) == :ok
  end

  test "validate: with a named, active node argument succeeds", context do
    assert @command.validate([], context[:opts]) == :ok
  end

  test "run: request to a named, active node succeeds", context do
    assert @command.run([], context[:opts])
  end

  test "run: request to a non-existent node returns nodedown" do
    target = :jake@thedog

    assert match?({:error, _}, @command.run([], %{node: target, timeout: 70000}))
  end

  test "banner", context do
    banner  = @command.banner([], context[:opts])

    assert banner =~ ~r/Will ping/
    assert banner =~ ~r/#{get_rabbit_hostname()}/
  end
end
