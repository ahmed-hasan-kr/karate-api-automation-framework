package com.qa.crmService.runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class CITestRunnerRPs {
    private static final Logger logger = LoggerFactory.getLogger(CITestRunnerRPs.class);

    public static final int THREADCOUNT = 5;
    @Test
    public void contractsInterfaceTest() {
        Results results = Runner
                        .path("src/test/java/com/krogerqa/contractsInterface")
                        .outputJunitXml(true)
                        .outputCucumberJson(true)
                        .outputHtmlReport(true)
                        .parallel(THREADCOUNT);
        generateReport(results.getReportDir());

        assertTrue((results.getFailCount() == 0), results.getErrorMessages());
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "Karate API : Contracts Interface Service");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}