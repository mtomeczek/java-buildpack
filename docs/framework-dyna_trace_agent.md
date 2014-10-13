# Dynatrace Agent Framework
The Dynatrace Agent Framework causes a dynatrace agent to be automatically downloaded and placed in a JAVA_OPTS to work with a dynatrace server.

<table>
  <tr>
    <td><strong>Detection Criterion</strong></td>
    <td><tt>DYNATRACE_SERVER</tt> environment variable set</td>
  </tr>
  <tr>
    <td><strong>Tags</strong></td>
   <td><tt>dyna-trace-agent=&lt;version&gt;</tt></td>
  </tr>
</table>
Tags are printed to standard output by the buildpack detect script


## Configuration
For general information on configuring the buildpack, refer to [Configuration and Extension][].

The framework can be configured by creating or modifying the [`config/dyna_trace_agent.yml`][] file in the buildpack fork.

| Name | Description
| ---- | -----------
| `repository_root` | The URL of the Auto-reconfiguration repository index ([details][repositories]).
| `version` | The version of Auto-reconfiguration to use. Candidate versions can be found in [this listing][].
| `wait` | See dynatrace documentation
| `transformationmaxavgwait` | See dynatrace documentation
| `storage` | See dynatrace documentation

## Example
```yaml
# Dynatrace agent configuration
---
wait: 45
transformationmaxavgwait: 256
storage: "."
```

[Configuration and Extension]: ../README.md#configuration-and-extension
[`config/dyna_trace_agent.yml`]: ../config/dyna_trace_agent.yml
[repositories]: extending-repositories.md
[this listing]: http://download.test.cf.hybris.com/dynatrace/index.yml
