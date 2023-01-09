# METADATA
# title :"GuardDuty is Enabled"
# description: "Ensures GuardDuty is enabled"
# scope: package
# schemas:
# - input: schema.input
# related_resources:
# - https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html
# custom:
#   avd_id: AVD-AWS-0180
#   provider: aws
#   service:GuardDuty
#   severity: LOW
#   short_code: guardduty-enabled 
#   recommended_action: "Enable GuardDuty for all AWS accounts."
#   input:
#     selector:
#      - type: cloud
package builtin.aws.rds.aws0180

#function(cache, settings, callback) {
#        var results = [];
#        var source = {};
#
#        var acctRegion = helpers.defaultRegion(settings);
#        var awsOrGov = helpers.defaultPartition(settings);
#        var accountId = helpers.addSource(cache, source, ['sts', 'getCallerIdentity', acctRegion, 'data']);
#
#        var regions = helpers.regions(settings);
#
#        async.each(regions.guardduty, function(region, rcb) {
#            var listDetectors = helpers.addSource(cache, source, ['guardduty', 'listDetectors', region]);
#            if (!listDetectors) return rcb();
#            if (listDetectors.err || !listDetectors.data) {
#                helpers.addResult(results, 3, 'Unable to list GuardDuty detectors: ' + helpers.addError(listDetectors), region);
#                return rcb();
#            }
#
#            // describe each detector
#            const detectors = listDetectors.data
#                .map(detectorId => {
#                    const getDetector = helpers.addSource(cache, source, ['guardduty', 'getDetector', region, detectorId]);
#                    if (!getDetector) return { Status: 'unknown' };
#                    if (getDetector.err || !getDetector.data) {
#                        helpers.addResult(results, 3, `Unable to get GuardDuty detector: ${helpers.addError(listDetectors)}`, region, detectorId);
#                        return { Status: 'unknown' };
#                    }
#                    return { detectorId, ...getDetector.data};
#                });
#
#            if (!detectors.length) {
#                helpers.addResult(results, 2, 'GuardDuty not enabled', region);
#            } else {
#                const enabledDetectors = detectors.filter(detector => detector.Status === 'ENABLED');
#                const badDetectors = detectors.filter(detector => detector.Status !== 'ENABLED');
#                if (enabledDetectors.length >= 1) {
#                    enabledDetectors.forEach(detector => {
#                        // arn:${Partition}:guardduty:${Region}:${Account}:detector/${DetectorId}
#                        var arn = 'arn:' + awsOrGov + ':guardduty:' + region + ':' + accountId + ':detector/' + detector.detectorId;
#                        helpers.addResult(results, 0, 'GuardDuty is enabled', region, arn);
#                    });
#                } else {
#                    badDetectors.forEach(detector => {
#                        var arn = 'arn:' + awsOrGov + ':guardduty:' + region + ':' + accountId + ':detector/' + detector.detectorId;
#                        helpers.addResult(results, 2, `GuardDuty detector is ${detector.Status}`, region, arn);
#                    });
#                }
#            }
#            rcb();
#        }, function(){
#            callback(null, results, source);
#        });
#    }