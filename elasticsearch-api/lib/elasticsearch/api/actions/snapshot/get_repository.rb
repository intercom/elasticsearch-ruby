# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Get information about snapshot repositories or a specific repository
        #
        # @example Get all repositories
        #
        #     client.snapshot.get_repository
        #
        # @example Get a specific repository
        #
        #     client.snapshot.get_repository repository: 'my-backups'
        #
        # @option arguments [List] :repository A comma-separated list of repository names. Leave blank or use `_all`
        #                                      to get a list of repositories
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Number,List] :ignore The list of HTTP errors to ignore
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def get_repository(arguments={})
          repository = arguments.delete(:repository)
          method = HTTP_GET
          path   = Utils.__pathify( '_snapshot', Utils.__escape(repository) )

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:get_repository, [
            :master_timeout,
            :local ].freeze)
      end
    end
  end
end
