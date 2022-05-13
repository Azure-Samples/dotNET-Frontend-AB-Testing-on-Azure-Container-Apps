using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.FeatureManagement.Mvc;

namespace TestFeatureFlags.Controllers
{
    public class BetaController : Controller
    {
        private readonly IFeatureManager _featureManager;
        private readonly TelemetryClient _telemetryClient;

        public BetaController(IFeatureManagerSnapshot featureManager, TelemetryClient telemetryClient)
        {
            _featureManager = featureManager;
            _telemetryClient = telemetryClient;
        }

        //[FeatureGate(MyFeatureFlags.Beta)]
        public IActionResult Index()
        {
            _telemetryClient.TrackEvent("Beta Page Loaded");
            return View();
        }
    }
}