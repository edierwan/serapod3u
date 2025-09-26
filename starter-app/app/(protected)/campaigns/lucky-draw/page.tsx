import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";

export default function LuckyDrawCampaigns() {
  const tabs = getPageTabs("/campaigns/lucky-draw");
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Lucky Draw Campaigns</h1>
        <p className="mt-1 text-sm text-gray-500">
          Manage lucky draw campaigns, entries, and results
        </p>
      </div>
      
      <TabBar tabs={tabs} basePath="/campaigns/lucky-draw">
        <div className="space-y-6">
          {/* Campaign Stats */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white p-6 rounded-lg shadow border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                    <span className="text-blue-600 font-semibold text-sm">🎲</span>
                  </div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Active Campaigns</p>
                  <p className="text-2xl font-semibold text-gray-900">3</p>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                    <span className="text-green-600 font-semibold text-sm">👥</span>
                  </div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Total Participants</p>
                  <p className="text-2xl font-semibold text-gray-900">1,247</p>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="w-8 h-8 bg-purple-100 rounded-full flex items-center justify-center">
                    <span className="text-purple-600 font-semibold text-sm">🏆</span>
                  </div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Prizes Awarded</p>
                  <p className="text-2xl font-semibold text-gray-900">89</p>
                </div>
              </div>
            </div>
          </div>

          {/* Campaign List */}
          <div className="bg-white shadow rounded-lg">
            <div className="px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-medium text-gray-900">Campaigns</h2>
              <p className="mt-1 text-sm text-gray-500">
                Manage your lucky draw campaigns and their settings
              </p>
            </div>
            <div className="p-6">
              <div className="space-y-4">
                <div className="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
                  <div>
                    <h3 className="text-base font-medium text-gray-900">Summer Prize Draw 2024</h3>
                    <p className="text-sm text-gray-500">Active • 156 participants</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      Active
                    </span>
                    <button className="text-blue-600 hover:text-blue-500 text-sm font-medium">
                      View Details
                    </button>
                  </div>
                </div>

                <div className="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
                  <div>
                    <h3 className="text-base font-medium text-gray-900">Monthly Mega Draw</h3>
                    <p className="text-sm text-gray-500">Active • 892 participants</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      Active
                    </span>
                    <button className="text-blue-600 hover:text-blue-500 text-sm font-medium">
                      View Details
                    </button>
                  </div>
                </div>

                <div className="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
                  <div>
                    <h3 className="text-base font-medium text-gray-900">Weekly Lucky Winners</h3>
                    <p className="text-sm text-gray-500">Active • 199 participants</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      Active
                    </span>
                    <button className="text-blue-600 hover:text-blue-500 text-sm font-medium">
                      View Details
                    </button>
                  </div>
                </div>
              </div>

              <div className="mt-6">
                <button className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                  <span className="mr-2">+</span>
                  Create New Campaign
                </button>
              </div>
            </div>
          </div>

          {/* Tab Information */}
          <div className="bg-blue-50 rounded-lg p-4">
            <p className="text-blue-800 text-sm">
              <strong>Active Tab:</strong> Campaigns - Use the tabs above to navigate between Campaigns, Entries, and Results.
            </p>
          </div>
        </div>
      </TabBar>
    </div>
  );
}