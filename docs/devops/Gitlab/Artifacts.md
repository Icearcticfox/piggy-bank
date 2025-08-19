
```
    artifacts:
        untracked: true
        paths:
            - build/
            - some/**/directories
        exclude:
            - build/dont-include-this-folder/
            - some/**/directories/*.txt
        expire: 1d 
```
- [# CI Artifacts: exclude paths](https://gitlab.com/gitlab-org/gitlab/-/issues/15122)
