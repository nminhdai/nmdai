#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    int findLength(vector<int>& nums1, vector<int>& nums2) {
        int ans = 0;
        for (int i = 0; i < nums1.size(); i++){
            for (int j = 0; j < nums2.size() - 1; j++){
                if (nums1[i] == nums2[j]) {
                    int k = 0;
                    while ((nums1[i+k] == nums2[j+k]) && 
                            (i + k < nums1.size()) && 
                            (j + k < nums2.size()))
                        k += 1;
                    if (k > ans) ans = k;
                }
            }       
        }
        return ans;
    }
};

int main(){
    Solution b;
    vector<int> nums1 = {0,0,0,0,0};
    vector<int> nums2 = {0,0,0,0,0};
    cout << b.findLength(nums1,nums2);
}