// If is a merge to master.
if (env.BRANCH_NAME == "master") {
    ciKubernetesDeploy {
        jobName = "go-project-template"
        serviceNamespace = "transactions"
        junitFilePath = "/home/gradle/project/build/test-results/test/TEST-br.com.guiabolso.go-project-template.ApplicationTest.xml"
    }
}

// If is a pull request.
if (env.CHANGE_ID) {
    ciRunTests {
        jobName = "go-project-template"
        junitFilePath = "/home/gradle/project/build/test-results/test/TEST-br.com.guiabolso.go-project-template.ApplicationTest.xml"
    }
}
