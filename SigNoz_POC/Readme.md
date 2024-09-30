
# SigNoz: Observability Tool

SigNoz is an open-source observability tool that helps in monitoring applications and troubleshooting problems. It provides storage, analysis, and visualization of telemetry data.

## Components

- **Otel Collector**
- **Clickhouse (OLAP DB)**
- **Query Service**
- **Frontend**

## Steps

1. **Install SigNoz**

	SigNoz recommends using the install script.

	```sh
	git clone -b main https://github.com/SigNoz/signoz.git && cd signoz/deploy/
	./install.sh
	```

	**NOTE:**
	- Make sure port 9000 is available.
	- Ensure the password does not contain numbers on the signup page.

2. **Install Self-Host OpenTelemetry Binary in Virtual Machine**

	OpenTelemetry binary acts as an agent, collecting telemetry data. Set up a host metrics receiver to collect metrics from the VM and view them in SigNoz.

	**NOTE:**
	- OTel v0.108.0

	```sh
	wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.108.0/otelcol-contrib_0.108.0_linux_amd64.deb
	sudo dpkg -i otelcol-contrib_0.108.0_linux_amd64.deb
	```

3. **OpenTelemetry Collector Configuration**

	Download the standalone configuration for the otelcol binary running in the VM.

	```sh
	wget https://raw.githubusercontent.com/SigNoz/benchmark/main/docker/standalone/config.yaml
	sudo dpkg -i otelcol-contrib_0.108.0_linux_amd64.deb
	```

4. **OpenTelemetry Collector Usage**

	Ensure `/etc/otelcol-contrib` has the right owner and permissions.

	```sh
	sudo chown -R otelcol-contrib:otelcol-contrib /etc/otelcol-contrib
	sudo chown otelcol-contrib:otelcol-contrib /usr/bin/otelcol-contrib
	```

5. **Test Sending Traces**

	Install the telemetry generator.

	```sh
	go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@latest
	```

	**NOTE:**
	- Install Go

	```sh
	GOROOT=/usr/local/go ...
	telemetrygen traces --traces 1 --otlp-endpoint localhost:4317 --otlp-insecure
	```

6. **Elixir OpenTelemetry Instrumentation**

	Send traces via the OTel Collector binary. Instrumentation is the act of adding observability code to an app yourself.

	- **Step 1:** Add dependencies (`mix.exs`)

	  ```elixir
	  {:opentelemetry_api, "~> 1.2"}
	  ```

	- **dev.exs**
	- **application.ex**

7. **Dashboard**

	- Set up OTel Collector as an agent (Different Machine).
	- Download/Copy the host metrics JSON file.
	- Import the host metrics JSON file to the SigNoz UI.

## OpenTelemetry: Agent

OpenTelemetry provides libraries for instrumenting the application and sending data to SigNoz.

Once you instrument your application with OpenTelemetry, you can send the data to SigNoz for storage, analysis, and visualization.
