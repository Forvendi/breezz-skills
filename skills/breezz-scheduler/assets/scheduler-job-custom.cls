public with sharing class MySchedulerJob implements forvendi.SchedulerJob {
    public forvendi.SchedulerJob init(forvendi.SchedulerJobInfo schedulerConfig) {
        return this;
    }

    public Boolean shouldRun() {
        return true;
    }

    public void run() {
        // Business logic here
    }
}
