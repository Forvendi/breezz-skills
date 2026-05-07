public with sharing class MySchedulerQueueable extends forvendi.SchedulerQueueable {
    public MySchedulerQueueable() {
        super(MySchedulerQueueable.class.getName());
    }

    public override forvendi.SchedulerJob init(forvendi.SchedulerJobInfo schedulerConfig) {
        return this;
    }

    public Boolean shouldRun() {
        return true;
    }

    public override void execute(forvendi.ModificationContext ctx) {
        // Business logic with ModificationContext access
    }
}
