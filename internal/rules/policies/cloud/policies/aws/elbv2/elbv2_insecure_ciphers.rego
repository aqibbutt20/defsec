# METADATA
# title :"ELBv2 Insecure Ciphers"
# description: "Ensure that Elbv2 listeners are configured to use the predefined security policies containing secure ciphers."
# scope: package
# schemas:
# - input: schema.input
# related_resources:
# - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-tls-listener.htmll
# custom:
#   avd_id: AVD-AWS-0180
#   provider: aws
#   service:ELBv2
#   severity: LOW
#   short_code: elbv2-insecure-ciphers 
#   recommended_action: "Modify ELBv2 listeners with the predefined AWS security policies containing secure ciphers."
#   input:
#     selector:
#      - type: cloud
package builtin.aws.rds.aws0180

#function(cache, settings, callback) {
#        var results = [];
#        var source = {};
#        var regions = helpers.regions(settings);
#
#        var deprecatedALBCipherPolicies = [
#            'ELBSecurityPolicy-TLS-1-2-2017-01',
#            'ELBSecurityPolicy-TLS-1-2-Ext-2018-06',
#            'ELBSecurityPolicy-FS-1-2-2019-08',
#            'ELBSecurityPolicy-FS-1-2-Res-2019-08',
#        ];
#
#        var deprecatedNLBCipherPolicies = [
#            'ELBSecurityPolicy-TLS13-1-2-2021-06',
#            'ELBSecurityPolicy-TLS13-1-2-Ext1-2021-06',
#            'ELBSecurityPolicy-TLS13-1-2-Ext2-2021-06',
#            'ELBSecurityPolicy-FS-1-2-Res-2020-10',
#            'ELBSecurityPolicy-FS-1-2-Res-2019-08',
#            'ELBSecurityPolicy-FS-1-2-2019-08',
#            'ELBSecurityPolicy-TLS-1-2-Ext-2018-06',
#            'ELBSecurityPolicy-TLS-1-2-2017-01',
#        ];
#
#        async.each(regions.elb, function(region, rcb){
#            var describeLoadBalancers = helpers.addSource(cache, source,
#                ['elbv2', 'describeLoadBalancers', region]);
#
#            if (!describeLoadBalancers) return rcb();
#
#            if (describeLoadBalancers.err || !describeLoadBalancers.data) {
#                helpers.addResult(results, 3,
#                    `Unable to query for load balancers: ${helpers.addError(describeLoadBalancers)}`,region);
#                return rcb();
#            }
#
#            if (!describeLoadBalancers.data.length) {
#                helpers.addResult(results, 0, 'No Application or Network load balancers found', region);
#                return rcb();
#            }
#
#            for (var alb of describeLoadBalancers.data){
#                if (!alb.DNSName) continue;
#
#                var depPolicies = [];
#                var SslPolicy = false;
#                var describeListeners = helpers.addSource(cache, source,
#                    ['elbv2', 'describeListeners', region, alb.DNSName]);
#
#                if (describeListeners.err || !describeListeners.data || !describeListeners.data.Listeners) {
#                    helpers.addResult(results, 3, `Unable to query for ELBv2 Listeners: ${helpers.addError(describeListeners)}`, region, alb.LoadBalancerArn);
#                    continue;
#                }
#
#                if (!describeListeners.data.Listeners.length) {
#                    helpers.addResult(results, 0, 'No Listeners found for load balancer', region, alb.LoadBalancerArn);
#                    continue;
#                }
#
#                describeListeners.data.Listeners.forEach(function(listener){
#                    if (listener.SslPolicy) {
#                        SslPolicy = true;
#                        if (deprecatedALBCipherPolicies.includes(listener.SslPolicy) || deprecatedNLBCipherPolicies.includes(listener.SslPolicy)) {
#                            depPolicies.push(listener.SslPolicy);
#                        }
#                    }
#                });
#                if (!SslPolicy){
#                    helpers.addResult(results, 0,'No SSL policies found for load balancer', region, alb.LoadBalancerArn);
#                } else if (depPolicies && depPolicies.length){
#                    helpers.addResult(results, 2, 'Load balancer listeners have these policies with insecure ciphers: ' + depPolicies.join(', '), region, alb.LoadBalancerArn);
#                } else {
#                    helpers.addResult(results, 0, 'Load balancer listeners policies contain secure ciphers', region, alb.LoadBalancerArn);
#                }
#            }
#            rcb();
#        }, function(){
#            callback(null, results, source);
#        });
#    }