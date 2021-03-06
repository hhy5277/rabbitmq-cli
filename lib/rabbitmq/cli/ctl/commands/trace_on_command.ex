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

defmodule RabbitMQ.CLI.Ctl.Commands.TraceOnCommand do
  @behaviour RabbitMQ.CLI.CommandBehaviour

  def merge_defaults(_, opts) do
    {[], Map.merge(%{vhost: "/"}, opts)}
  end

  use RabbitMQ.CLI.Core.AcceptsNoPositionalArguments
  use RabbitMQ.CLI.Core.RequiresRabbitAppRunning

  def run([], %{node: node_name, vhost: vhost}) do
    case :rabbit_misc.rpc_call(node_name, :rabbit_trace, :start, [vhost]) do
      :ok -> {:ok, "Trace enabled for vhost #{vhost}"}
      other -> other
    end
  end

use RabbitMQ.CLI.DefaultOutput

  def usage, do: "trace_on [--vhost <vhost>]"

  def help_section(), do: :virtual_hosts

  def banner(_, %{vhost: vhost}), do: "Starting tracing for vhost \"#{vhost}\" ..."
end
