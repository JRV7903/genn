#include "backends/ispc/backend.h"

// Standard C++ includes
#include <string>

// GeNN includes
#include "gennUtils.h"

//--------------------------------------------------------------------------
// GeNN::CodeGenerator::ISPC::Preferences
//--------------------------------------------------------------------------
namespace GeNN::CodeGenerator::ISPC
{
void Preferences::updateHash(boost::uuids::detail::sha1 &hash) const
{
    // Superclass
    PreferencesBase::updateHash(hash);

    // Update hash with preferences
    Utils::updateHash(targetISA, hash);
    Utils::updateHash(maximizeUniforms, hash);
    Utils::updateHash(debugCode, hash);
    Utils::updateHash(optimizeCode, hash);
    Utils::updateHash(optimizeForSize, hash);
}

const char *Preferences::getImportSuffix() const
{
    return "_ISPC";
}
}  // namespace GeNN::CodeGenerator::ISPC 