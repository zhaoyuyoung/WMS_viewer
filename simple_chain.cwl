cwlVersion: v1.0
class: Workflow

inputs: []

outputs:
    outDS:
        type: string
        outputSource: eventselection-2/outDS

steps:
    eventselection-1:
        run: reana
        in:
            opt_containerImage:
                default: docker://gitlab-registry.cern.ch/zhangruihpc/iddsal:atlas-reana-submitter
            opt_exec:
                default: "source script_eos.sh from_pchain_eos %IN"
            opt_args:
                default: "--disableAutoRetry --site  CERN --outputs out-eos-1.tar --useSecrets"
        out: [outDS]
    
    eventselection-2:
        run: reana
        in:
            opt_inDS: eventselection-1/outDS
            opt_containerImage:
                default: docker://gitlab-registry.cern.ch/zhangruihpc/iddsal:atlas-reana-submitter
            opt_exec:
                default: "source script_rucio.sh from_pchain_rucio %{DS0}"
            opt_args:
                default: "--disableAutoRetry --site  CERN --outputs out-rucio-2.tar --useSecrets"
        out: [outDS]
