cwlVersion: v1.0
class: Workflow

inputs:
    dataset:
        type: string
    param_xxx:
        type: int
        default: 100

outputs:
    outDS:
        type: string
        outputSource: inner_work_bottom/outDS


steps:
    inner_work_top:
        run: reana
        in:
            opt_inDS:
                - dataset
            opt_containerImage:
                default: docker://gitlab-registry.cern.ch/zhangruihpc/iddsal:atlas-reana-submitter
            opt_exec:
                default: "source script_rucio.sh from_pchloop_rucio"
            opt_args:
                default: "--disableAutoRetry --site  CERN --outputs out-rucio-1.tar --useSecrets"
        out: [outDS]

    inner_work_bottom:
        run: reana
        in:
            opt_inDS:
                - inner_work_top/outDS
                - dataset
            opt_containerImage:
                default: docker://gitlab-registry.cern.ch/zhangruihpc/iddsal:atlas-reana-submitter
            opt_exec:
                default: "source script_eos.sh from_pchloop_eos"
            opt_args:
                default: "--disableAutoRetry --site  CERN --outputs out-eos-1.tar --useSecrets"
        out: [outDS]
    
    checkpoint:
        run: junction
        in:
            opt_inDS:
                - inner_work_top/outDS
                - inner_work_bottom/outDS
            opt_exec:
                default: "echo %{DS0} %{DS1} aaaa; echo '{\"x\": 456, \"to_exit\": true}' > results.json"
        out: []
